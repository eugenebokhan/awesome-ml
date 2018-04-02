//
//  OpenPoseViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import CoreMedia
import VideoToolbox

class OpenPoseViewController: RunCoreMLViewController {
    
    var drawLayer: CALayer!

    override func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        videoCapture.setUp(sessionPreset: AVCaptureSession.Preset.vga640x480) { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // Add the bounding box layers to the UI, on top of the video preview.
                self.setupDrawLayer()
                
                // Once everything is set up, we can start capturing live video.
                self.videoCapture.start()
            }
        }
    }
    
    func setupDrawLayer() {
        drawLayer = CALayer()
        
        let width = videoPreview.bounds.width
        
        let scaleX = width / CGFloat(coreMLModel.inputWidth)
        let scaleY = CGFloat(coreMLModel.inputHeight) / width
        
        // Translate and scale the rectangle to our own coordinate system.
        drawLayer.frame = videoPreview.bounds
        
        drawLayer.frame.size.width *= scaleX
        drawLayer.frame.size.height *= scaleY
        
        drawLayer.opacity = 0.6
        drawLayer.masksToBounds = true
    }
    
    // MARK: - CoreML Methods
    
    // Old Methods
    func predict(image: UIImage) {
        if let pixelBuffer = image.pixelBuffer(width: coreMLModel.inputWidth, height: coreMLModel.inputHeight) {
            predict(pixelBuffer: pixelBuffer)
        }
    }
    
    func predict(pixelBuffer: CVPixelBuffer) {
        
        // Resize the input with Core Image to 368x368.
        guard let resizedPixelBuffer = resizedPixelBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(coreMLModel.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(coreMLModel.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        ciContext.render(scaledImage, to: resizedPixelBuffer)
        
        // Resize the input to 368x368 and give it to our model.
        if let prediction = try? mobileOpenPose.prediction(image: resizedPixelBuffer) {
            
            let predictionOutput = prediction.net_output
            let length = predictionOutput.count
            print(predictionOutput)
            
            let doublePointer =  predictionOutput.dataPointer.bindMemory(to: Double.self, capacity: length)
            let doubleBuffer = UnsafeBufferPointer(start: doublePointer, count: length)
            let mm = Array(doubleBuffer)
            
            // Delete Beizer paths of previous image
            drawLayer.removeFromSuperlayer()
            // Draw new lines
            drawLines(mm)
            
            self.semaphore.signal()
        }
    }
    
    override func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let features = observations.first?.featureValue.multiArrayValue {
            
            let length = features.count
            print(features)
            
            let doublePointer =  features.dataPointer.bindMemory(to: Double.self, capacity: length)
            let doubleBuffer = UnsafeBufferPointer(start: doublePointer, count: length)
            let mm = Array(doubleBuffer)
            
            // Delete Beizer paths of previous image
            drawLayer.removeFromSuperlayer()
            // Draw new lines
            drawLines(mm)
            
            self.semaphore.signal()
        }
    }
    
    // MARK: - Drawing
    
    func drawLines(_ mm: Array<Double>){
        
        let poseEstimator = PoseEstimator(coreMLModel.inputWidth, coreMLModel.inputHeight)
        
        let res = measure(poseEstimator.estimate(mm))
        let humans = res.result;
        print("estimate \(res.duration)")
        
        var keypoint = [Int32]()
        var pos = [CGPoint]()
        for human in humans {
            var centers = [Int: CGPoint]()
            for i in 0...CocoPart.Background.rawValue {
                if human.bodyParts.keys.index(of: i) == nil {
                    continue
                }
                let bodyPart = human.bodyParts[i]!
                centers[i] = CGPoint(x: bodyPart.x, y: bodyPart.y)
            }
            
            for (pairOrder, (pair1,pair2)) in CocoPairsRender.enumerated() {
                
                if human.bodyParts.keys.index(of: pair1) == nil || human.bodyParts.keys.index(of: pair2) == nil {
                    continue
                }
                if centers.index(forKey: pair1) != nil && centers.index(forKey: pair2) != nil{
                    keypoint.append(Int32(pairOrder))
                    pos.append(centers[pair1]!)
                    pos.append(centers[pair2]!)
                }
            }
        }
        
        let openCVWrapper = OpenCVWrapper()
        
        if let renderedImage = openCVWrapper.renderKeyPoint(videoPreview.frame,
                                                            keypoint: &keypoint,
                                                            keypoint_size: Int32(keypoint.count),
                                                            pos: &pos) {
            drawLayer.contents = renderedImage.cgImage
        }
        
        videoPreview.layer.addSublayer(drawLayer)
        
    }
    
    override func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // For debugging.
        //predict(image: UIImage(named: "dog416")!); return
        
        semaphore.wait()
        
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            DispatchQueue.main.async {
                self.outputLabel.text = self.measure(self.predictUsingVision(pixelBuffer: pixelBuffer)).duration
//                self.outputLabel.text = self.measure(self.predict(pixelBuffer: pixelBuffer)).duration
            }
        }
    }
    
}
