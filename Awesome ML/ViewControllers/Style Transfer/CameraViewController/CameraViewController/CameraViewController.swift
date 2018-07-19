//
//  CameraViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

@available(iOS, deprecated: 9.0)
class CameraViewController: UIViewController {
    
    // UI Elements
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var focusView: UIView!
    @IBOutlet weak var changeFlashModeButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var topVisualEffectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomVisualEffectViewHeightConstraint: NSLayoutConstraint!
    
    // UI Actions
    
    @IBAction func switchCameraAction(_ sender: Any) {
        if let newSession = session {
            let currentCameraInput: AVCaptureInput = newSession.inputs[0]
            newSession.removeInput(currentCameraInput)
            var newCamera: AVCaptureDevice
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
                newCamera = self.cameraWithPosition(.front)!
            } else {
                newCamera = self.cameraWithPosition(.back)!
            }
            
            do {
                let newVideoInput = try AVCaptureDeviceInput(device: newCamera)
                if session!.canAddInput(newVideoInput) {
                    session?.addInput(newVideoInput)
                }
            } catch let error as NSError {
                input = nil
                isAllowedToUseCamera = false
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        
        self.view.isUserInteractionEnabled = false
        
        guard imageOutput != nil else {
            return
        }
        
        if let videoConnection = imageOutput.connection(with: AVMediaType.video) {
            imageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                
                if (imageDataSampleBuffer != nil){
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                    
                    var image = UIImage(data: imageData!)
                    
                    if (image != nil){
                        
                        //crop image like imageView
                        image = self.cropCameraImage(image!, previewLayer: self.prevLayer!)
                        
                        self.onCompletion!(image)
                        self.stopCamera()
                        self.view.isUserInteractionEnabled = true
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        self.onCompletion!(nil)
                        self.stopCamera()
                    }
                    
                }
            }
        }
    }
    
    @IBAction func changeFlashModeAction(_ sender: Any) {
        
        do {
            try device!.lockForConfiguration()
            if (device?.flashMode == .auto){
                device?.flashMode = .on
                changeFlashModeButton.setImage(UIImage(named: "flashOn") , for: UIControl.State())
            }else if (device?.flashMode == .on){
                device?.flashMode = .off
                changeFlashModeButton.setImage(UIImage(named: "flashOff") , for: UIControl.State())
            }else{
                device?.flashMode = .auto
                changeFlashModeButton.setImage(UIImage(named: "flashAuto") , for: UIControl.State())
            }
            device!.unlockForConfiguration()
        } catch _ { }
    }
    
    @IBAction func exitAction(_ sender: Any) {
        closeCamera()
    }
    
    // MARK: - Properties
    
    var onCompletion: ((UIImage?) -> Void)?
    
    //data session
    var session: AVCaptureSession?
    var prevLayer: AVCaptureVideoPreviewLayer?
    
    //input
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    
    //ouput
    var imageOutput: AVCaptureStillImageOutput!
    
    //default value
    var switchCamera  = false
    var isAllowedToUseCamera = true
    
    // MARK: - Lifecycle Methods
    
    init(completion: @escaping ((UIImage?) -> Void)) {
        super.init(nibName: nil, bundle: nil)
        onCompletion = completion
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSession()
        setupFocusView()
        setupGestures()
        setupBottomVisualEffectViewHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideUIElements(animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.showUIElements(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if  !isAllowedToUseCamera {
            showAllowAccessAlert()
        }
        
        prevLayer?.frame.size = imageView.frame.size
        self.focusCamera(self.imageView.center)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideUIElements(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.61) {
            self.showUIElements(animated: false)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.prevLayer?.connection?.videoOrientation = self.transformOrientation(UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
            self.prevLayer?.frame.size = self.imageView.frame.size
        }, completion: { (context) -> Void in
            
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - Setup Methods
    
    func setupFocusView() {
        focusView.layer.borderWidth = 1.0
        focusView.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor
        focusView.isHidden = true
    }
    
    func setupGestures() {
        
        if let gestureRecognizers = self.view.gestureRecognizers {
            gestureRecognizers.forEach({ self.view.removeGestureRecognizer($0) })
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focus(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(focusView)
        if  switchCamera == true  && input != nil{
            self.switchCameraAction(switchCamera as AnyObject)
        }
    }
    
    func setupBottomVisualEffectViewHeight() {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        bottomVisualEffectViewHeightConstraint.constant = screenHeight - topVisualEffectViewHeightConstraint.constant - screenWidth
    }
    
    // MARK: - UI Methods
    
    func hideUIElements(animated: Bool) {
        
        let topElemetsTranslationY: CGFloat = -100
        let bottomElemetsTranslationY: CGFloat = 200
        
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8, animations: {
                self.exitButton.transform = CGAffineTransform(translationX: 0, y: topElemetsTranslationY)
                self.changeFlashModeButton.transform = CGAffineTransform(translationX: 0, y: bottomElemetsTranslationY)
                self.switchCameraButton.transform = CGAffineTransform(translationX: 0, y: bottomElemetsTranslationY)
                self.takePhotoButton.transform = CGAffineTransform(translationX: 0, y: bottomElemetsTranslationY)
            })
            animator.startAnimation()
            
        } else {
            self.exitButton.transform = CGAffineTransform(translationX: 0, y: topElemetsTranslationY)
            self.changeFlashModeButton.transform = CGAffineTransform(translationX: 0, y: bottomElemetsTranslationY)
            self.switchCameraButton.transform = CGAffineTransform(translationX: 0, y: bottomElemetsTranslationY)
            self.takePhotoButton.transform = CGAffineTransform(translationX: 0, y: bottomElemetsTranslationY)
        }
        
    }
    
    func showUIElements(animated: Bool) {
        
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8, animations: {
                self.exitButton.transform = .identity
                self.changeFlashModeButton.transform = .identity
                self.switchCameraButton.transform = .identity
                self.takePhotoButton.transform = .identity
            })
            animator.startAnimation()
            
        } else {
            self.exitButton.transform = .identity
            self.changeFlashModeButton.transform = .identity
            self.switchCameraButton.transform = .identity
            self.takePhotoButton.transform = .identity
        }
        
    }
    
    // MARK: - Camera Methods
    
    @objc internal func focus(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        CameraAnimaion(point)
    }
    
    internal func CameraAnimaion(_ point : CGPoint) {
        guard focusCamera(point) else {
            return
        }
        
        focusView.isHidden = false
        focusView.center = point
        focusView.alpha = 0
        focusView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        self.view.bringSubviewToFront(focusView)
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: { () -> Void in
                self.focusView.alpha = 1
                self.focusView.transform = CGAffineTransform.identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.80, relativeDuration: 0.20, animations: { () -> Void in
                self.focusView.alpha = 0
                self.focusView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            
            
        }, completion: { finished in
            if finished {
                self.focusView.isHidden = true
            }
        })
    }
    
    @discardableResult internal func focusCamera(_ toPoint: CGPoint) -> Bool {
        
        guard toPoint.y > self.imageView.frame.origin.y && toPoint.y < self.imageView.frame.origin.y + self.imageView.frame.size.height else {
            return false
        }
        
        guard let device = device , device.isFocusModeSupported(.continuousAutoFocus) else {
            return false
        }
        
        do { try device.lockForConfiguration() } catch {
            return false
        }
        
        // focus points are in the range of 0...1, not screen pixels
        let focusPoint = CGPoint(x: toPoint.x / self.view.frame.width, y: toPoint.y / self.view.frame.height)
        
        device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
        device.exposurePointOfInterest = focusPoint
        device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
        device.unlockForConfiguration()
        
        return true
    }
    
    func cropCameraImage(_ original: UIImage, previewLayer: AVCaptureVideoPreviewLayer) -> UIImage? {
        
        var image = UIImage()
        
        let previewImageLayerBounds = previewLayer.bounds
        
        let originalWidth = original.size.width
        let originalHeight = original.size.height
        
        let A = previewImageLayerBounds.origin
        let B = CGPoint(x: previewImageLayerBounds.size.width, y: previewImageLayerBounds.origin.y)
        let D = CGPoint(x: previewImageLayerBounds.size.width, y: previewImageLayerBounds.size.height)
        
        let a = previewLayer.captureDevicePointConverted(fromLayerPoint: A)
        let b = previewLayer.captureDevicePointConverted(fromLayerPoint: B)
        let d = previewLayer.captureDevicePointConverted(fromLayerPoint: D)
        
        let posX = floor(b.x * originalHeight)
        let posY = floor(b.y * originalWidth)
        
        let width: CGFloat = d.x * originalHeight - b.x * originalHeight
        let height: CGFloat = a.y * originalWidth - b.y * originalWidth
        
        let cropRect = CGRect(x: posX, y: posY, width: width, height: height)
        
        if let imageRef = original.cgImage?.cropping(to: cropRect) {
            image = UIImage(cgImage: imageRef, scale: original.scale, orientation: original.imageOrientation)
        }
        
        return image
    }
    
    func stopCamera() {
        self.session?.stopRunning()
        self.prevLayer?.removeFromSuperlayer()
        self.session = nil
        self.input = nil
        self.imageOutput = nil
        self.prevLayer = nil
        self.device = nil
    }
    
    
    func createSession() {
        session = AVCaptureSession()
        device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch let error as NSError {
            input = nil
            isAllowedToUseCamera = false
            print("Error: \(error.localizedDescription)")
            return
        }
        
        if session!.canAddInput(input!) {
            session!.addInput(input!)
        }
        
        let outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
        imageOutput = AVCaptureStillImageOutput()
        imageOutput.outputSettings = outputSettings
        session!.addOutput(imageOutput)
        
        prevLayer = AVCaptureVideoPreviewLayer(session: session!)
        prevLayer?.frame.size = imageView.frame.size
        prevLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        imageView.layer.addSublayer(prevLayer!)
        
        session?.startRunning()
    }
    
    // MARK: - Helpers
    
    func showAllowAccessAlert() {
        
        let alert = UIAlertController(title: "", message: "Please Allow Access to Your Camera.\n Go Setting", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            self.closeCamera()
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.openURL(settingsUrl)
            }
            self.closeCamera()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if (device as AnyObject).position == position {
                return device
            }
        }
        return nil
    }
    
    
    func isAvailablePhotoLibrary() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
    }
    
    func transformOrientation(_ orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    // MARK: - Exit
    
    func closeCamera() {
        self.dismiss(animated: true) {
            self.view.isUserInteractionEnabled = false
            self.stopCamera()
            self.onCompletion!(nil)
        }
    }
    
}
