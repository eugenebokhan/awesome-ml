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

class RunCoreMLViewController: UIViewController, VideoCaptureDelegate {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var inputWidthAndHeightLabel: UILabel!
    
    @IBOutlet weak var bottomBlurView: UIVisualEffectView!
    @IBOutlet weak var bottomBlurViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Interface Actions
    
    @IBAction func closeAction(_ sender: Any) {
        videoCapture.stop()
        dismiss(animated: true)
    }
    
    // MARK: - CoreML Properties
    
    var coreMLModel: CoreMLModel! { didSet { setupCoreMLModel() } }
    var mobileOpenPose: MobileOpenPose! { didSet { visionModel = try? VNCoreMLModel(for: mobileOpenPose.model) } }
    var tinyYOLO: TinyYOLO! { didSet { visionModel = try? VNCoreMLModel(for: tinyYOLO.model) } }
    var ageNet: AgeNet! { didSet { visionModel = try? VNCoreMLModel(for: ageNet.model) } }
    var carRecognition: CarRecognition! { didSet { visionModel = try? VNCoreMLModel(for: carRecognition.model) } }
    var flickrStyle: FlickrStyle! { didSet { visionModel = try? VNCoreMLModel(for: flickrStyle.model) } }
    var food101: Food101! { didSet { visionModel = try? VNCoreMLModel(for: food101.model) } }
    var genderNet: GenderNet! { didSet { visionModel = try? VNCoreMLModel(for: genderNet.model) } }
    var googLeNetPlaces: GoogLeNetPlaces! { didSet { visionModel = try? VNCoreMLModel(for: googLeNetPlaces.model) } }
    var inceptionv3: Inceptionv3! { didSet { visionModel = try? VNCoreMLModel(for: inceptionv3.model) } }
    var mnist: MNIST! { didSet { visionModel = try? VNCoreMLModel(for: mnist.model) } }
    var mobileNet: MobileNet! { didSet { visionModel = try? VNCoreMLModel(for: mobileNet.model) } }
    var nudity: Nudity! { didSet { visionModel = try? VNCoreMLModel(for: nudity.model) } }
    var oxford102: Oxford102! { didSet { visionModel = try? VNCoreMLModel(for: oxford102.model) } }
    var resnet50: Resnet50! { didSet { visionModel = try? VNCoreMLModel(for: resnet50.model) } }
    var visualSentimentCNN: VisualSentimentCNN! { didSet { visionModel = try? VNCoreMLModel(for: visualSentimentCNN.model) } }
    
    // MARK: - Vision Properties
    
    var request: VNCoreMLRequest!
    var visionModel: VNCoreMLModel! {
        didSet {
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            // NOTE: If you choose another crop/scale option, then you must also
            // change how the BoundingBox objects get scaled when they are drawn.
            // Currently they assume the full input image is used.
            request.imageCropAndScaleOption = .scaleFill
        }
    }
    let ciContext = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?
    let semaphore = DispatchSemaphore(value: 2)
    
    // MARK: - AV Property
    
    var videoCapture: VideoCapture!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCoreImage()
        setUpVision()
        setUpCamera()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
        resizeBottomBlurView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Just to be sure
        videoCapture.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    // MARK: - UI stuff
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func resizeBottomBlurView() {
        let height = view.bounds.size.height - view.bounds.size.width
        bottomBlurViewHeightConstraint.constant = height
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    // MARK: - Setup Methods
    
    func setupCoreMLModel() {
        
        if let compiledAddress = coreMLModel.localCompiledURL {
            switch coreMLModel.machineLearningModelType {
            case .mobileOpenPose?:
                if let model = try? MobileOpenPose(contentsOf: compiledAddress) {
                    mobileOpenPose = model
                }
            case .tinyYOLO?:
                if let model = try? TinyYOLO(contentsOf: compiledAddress) {
                    tinyYOLO = model
                }
            case .ageNet?:
                if let model = try? AgeNet(contentsOf: compiledAddress) {
                    ageNet = model
                }
            case .carRecognition?:
                if let model = try? CarRecognition(contentsOf: compiledAddress) {
                    carRecognition = model
                }
            case .flickrStyle?:
                if let model = try? FlickrStyle(contentsOf: compiledAddress) {
                    flickrStyle = model
                }
            case .food101?:
                if let model = try? Food101(contentsOf: compiledAddress) {
                    food101 = model
                }
            case .genderNet?:
                if let model = try? GenderNet(contentsOf: compiledAddress) {
                    genderNet = model
                }
            case .googleNetPlaces?:
                if let model = try? GoogLeNetPlaces(contentsOf: compiledAddress) {
                    googLeNetPlaces = model
                }
            case .inceptionv3?:
                if let model = try? Inceptionv3(contentsOf: compiledAddress) {
                    inceptionv3 = model
                }
            case .mnist?:
                if let model = try? MNIST(contentsOf: compiledAddress) {
                    mnist = model
                }
            case .mobileNet?:
                if let model = try? MobileNet(contentsOf: compiledAddress) {
                    mobileNet = model
                }
            case .nudity?:
                if let model = try? Nudity(contentsOf: compiledAddress) {
                    nudity = model
                }
            case .oxford102?:
                if let model = try? Oxford102(contentsOf: compiledAddress) {
                    oxford102 = model
                }
            case .resnet50?:
                if let model = try? Resnet50(contentsOf: compiledAddress) {
                    resnet50 = model
                }
            case .visualSentimentCNN?:
                if let model = try? VisualSentimentCNN(contentsOf: compiledAddress) {
                    visualSentimentCNN = model
                }

            default:
                break
            }
        }
    }
    
    func setUpCoreImage() {
        
        let status = CVPixelBufferCreate(nil, coreMLModel.inputWidth, coreMLModel.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        
        inputWidthAndHeightLabel.text = "[\(coreMLModel.inputWidth!)x\(coreMLModel.inputHeight!)]"
        
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    func setUpVision() {
        // This method will be overriden
    }
    
    func setUpCamera() {
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
                
                // Once everything is set up, we can start capturing live video.
                self.videoCapture.start()
            }
        }
    }
    
    // MARK: - Doing inference
    
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else { return }
        
        guard let firstResult = results.first else {return}
        DispatchQueue.main.async {
            let resultText = "\(firstResult.identifier)".capitalized
            let percentageText = "\(round(firstResult.confidence * 100)) %"
            self.showOnMainThread("Result: \(resultText)\nConfidence: \(percentageText)")
        }
    }
    
    func showOnMainThread(_ outputText: String) {
        
        DispatchQueue.main.async {
            self.outputLabel.text = outputText
            self.semaphore.signal()
        }
    }
    
    // MARK: - Help Methods
    
    func measure <T> (_ f: @autoclosure () -> T) -> (result: T, duration: String) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = f()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        let timeElapsedString = String(format: "%.0001f", timeElapsed)
        return (result, "Elapsed time is \n\(timeElapsedString) seconds.")
    }
    
    // MARK: - VideoCaptureDelegate
    
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        
        semaphore.wait()
        
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            DispatchQueue.main.async {
                self.predictUsingVision(pixelBuffer: pixelBuffer)
            }
        }
    }
    
}
