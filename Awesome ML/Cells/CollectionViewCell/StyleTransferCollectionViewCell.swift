//
//  StyleTransferCollectionViewCell.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/5/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit
import CoreML

class StyleTransferCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var getModelButtonBackgroundView: UIView!
    @IBOutlet weak var getModelButton: UIButton!
    @IBOutlet weak var getModelButtonBackgroundTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var getModelButtonBackgroundLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var getModelButtonBackgroundViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - UI Actions
    
    @IBAction func getModelAction(_ sender: Any) {
        
        animteButtonToProgress()
        downloadModel()
        
    }
    
    // MARK: - CoreML Properties
    
    var coreMLModel: CoreMLModel! {
        didSet {
            setupCoreMLModel()
            setupLabels()
            setupBackgrounImage()
            configureDarkViewAppearance()
        }
    }
    var fnsWave: FNSWave!
    var fnsRainPrincess: FNSRainPrincess!
    var fnsCandy: FNSCandy!
    var fnsTheScream: FNSTheScream!
    var fnsUndie: FNSUdnie!
    var fnsLaMuse: FNSLaMuse!
    var fnsMosaic: FNSMosaic!
    var fnsFeathers: FNS_Feathers!
    
    // MARK: - Download Properties
    
    let progressButton = DownloadButton()
    let downloadManager = DownloadManager()
    
    // Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        configure(downloadManager)
        configure(progressButton)
    }
    
    // Setup Methods
    
    func setupLabels() {
        
        DispatchQueue.main.async {
            self.title.text = self.coreMLModel.name
            self.title.createShadow()
        }
    }
    
    func setupBackgrounImage() {
        
        DispatchQueue.main.async {
            self.backgroundImageView.image = self.coreMLModel.image
        }
    }
    
    func setupCoreMLModel() {
        
        DispatchQueue.global(qos: .background).async {
            if let compiledAddress = self.coreMLModel.localCompiledURL {
                switch self.coreMLModel.coreMLType {
                case .fnsRainPrincess:
                    if let model = try? FNSRainPrincess(contentsOf: compiledAddress) {
                        self.fnsRainPrincess = model
                    }
                case .fnsWave:
                    if let model = try? FNSWave(contentsOf: compiledAddress) {
                        self.fnsWave = model
                    }
                case .fnsCandy:
                    if let model = try? FNSCandy(contentsOf: compiledAddress) {
                        self.fnsCandy = model
                    }
                case .fnsTheScream:
                    if let model = try? FNSTheScream(contentsOf: compiledAddress) {
                        self.fnsTheScream = model
                    }
                case .fnsUndie:
                    if let model = try? FNSUdnie(contentsOf: compiledAddress) {
                        self.fnsUndie = model
                    }
                case .fnsLaMuse:
                    if let model = try? FNSLaMuse(contentsOf: compiledAddress) {
                       self.fnsLaMuse = model
                    }
                case .fnsMosaic:
                    if let model = try? FNSMosaic(contentsOf: compiledAddress) {
                        self.fnsMosaic = model
                    }
                case .fnsFeathers:
                    if let model = try? FNS_Feathers(contentsOf: compiledAddress) {
                        self.fnsFeathers = model
                    }
                    
                default:
                    break
                }
            }
        }
    }
    
}

// MARK: - DownloadManager Delegate

extension StyleTransferCollectionViewCell: DownloadManagerDelegate {
    
    func configure(_ downloadManager: DownloadManager) {
        downloadManager.delegate = self
    }
    
    func downloadModel() {
        if let remoteUrl = coreMLModel.remoteURL {
            downloadManager.downloadFile(fromURL: remoteUrl, toDirectory: .documentDirectory, domainMask: .userDomainMask)
        }
    }
    
    func didLoadData(bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if progressButton.state == .pending {
            progressButton.state = .downloading
        }
        
        // Update the progress asyncroniusly.
        DispatchQueue.main.async {
            let progress: CGFloat = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
            self.progressButton.stopDownloadButton.progress = progress
        }
    }
    
    func didFinishDownloadingFile(destinationURL: URL) {
        
        progressButton.state = .pending
        
        compileModel(modelURL: destinationURL, completion: {
            self.animateProgressToButton()
            self.animateDarkViewDisappearance()
        })
        
        //        unarchiveModel(modelURL: destinationURL, completion: {
        //            self.animateProgressToButton()
        //            self.configureGetModelButtonAppearance()
        //        })
    }
    
    func didCompleteWithError(error: Error?) {
        
        animateProgressToButton()
        print("Model download did fail")
        
    }
    
    func isModelDownloaded() -> Bool {
        return CoreMLStore.isModelDownloaded(coreMLModel: coreMLModel)
    }
    
}

// MARK: - CoreML Stuff

extension StyleTransferCollectionViewCell {
    
    func compileModel(modelURL: URL, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            // Compile model
            guard let compiledAddress = try? MLModel.compileModel(at: modelURL) else { return }
            
            // Move compiled files to documents folder
            do {
                try FileManager.default.moveItem(at: compiledAddress, to: self.coreMLModel.localCompiledURL)
            } catch {
                print("An error occurred while moving file to localCompiledURL url")
            }
            
            // Delete temporary files files
            do {
                try FileManager.default.removeItem(at: modelURL)
            } catch {
                print("An error occurred while removing file to destinationURL url")
            }
            
            self.setupCoreMLModel()
            
            completion()
            
            print("Did Finish Download")
        }
        
    }
    
    func unarchiveModel(modelURL: URL, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            // Unarchive zip
            do {
                let _ = try Zip.quickUnzipFile(modelURL)
            }
            catch {
                print("Something went wrong")
            }
            
            // Delete temporary files files
            do {
                try FileManager.default.removeItem(at: modelURL)
            } catch {
                print("An error occurred while removing file to destinationURL url")
            }
            
            completion()
            
            print("Did Finish Download")
            
        }
        
    }
    
    func runModel(originalImage: UIImage, completion: @escaping (_ stylizedImage: UIImage) -> Void) {
        
        let resizedImage = originalImage.resize(to: CGSize(width: coreMLModel.inputWidth, height: coreMLModel.inputHeight))
        guard let resizedImageBuffer = resizedImage.buffer() else { return }
        
        switch coreMLModel.coreMLType {
        case .normal:
            completion(originalImage)
        case .fnsCandy:
            if let stylizedImageBuffer = try? fnsCandy.prediction(inputImage: resizedImageBuffer).outputImage,
                let resultImage = UIImage(imageBuffer: stylizedImageBuffer) { completion(resultImage) }
        case .fnsTheScream:
            if let stylizedImageBuffer = try? fnsTheScream.prediction(inputImage: resizedImageBuffer).outputImage,
                let resultImage = UIImage(imageBuffer: stylizedImageBuffer) { completion(resultImage) }
        case .fnsUndie:
            if let stylizedImageBuffer = try? fnsUndie.prediction(inputImage: resizedImageBuffer).outputImage,
                let resultImage = UIImage(imageBuffer: stylizedImageBuffer) { completion(resultImage) }
        case .fnsLaMuse:
            if let stylizedImageBuffer = try? fnsLaMuse.prediction(inputImage: resizedImageBuffer).outputImage,
                let resultImage = UIImage(imageBuffer: stylizedImageBuffer) { completion(resultImage) }
        case .fnsMosaic:
            if let stylizedImageBuffer = try? fnsMosaic.prediction(inputImage: resizedImageBuffer).outputImage,
                let resultImage = UIImage(imageBuffer: stylizedImageBuffer) { completion(resultImage) }
        case .fnsFeathers:
            if let stylizedImageBuffer = try? fnsFeathers.prediction(inputImage: resizedImageBuffer).outputImage,
                let resultImage = UIImage(imageBuffer: stylizedImageBuffer) { completion(resultImage) }
        default:
            completion(originalImage)
        }
        
    }
    
}

// MARK: - Download Button & Download Background View Stuff

extension StyleTransferCollectionViewCell: DownloadButtonDelegate {
    
    func configure(_ downloadButton: DownloadButton) {
        downloadButton.delegate = self
        downloadButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        downloadButton.tintColor = #colorLiteral(red: 0.9246864915, green: 0.9253881574, blue: 0.9247950912, alpha: 1)
    }
    
    func downloadButtonTapped(_ downloadButton: DownloadButton!, currentState state: DownloadButtonState) {
        
        switch state {
        case .startDownload:
            break
        case .pending:
            break
        case .downloading:
            downloadManager.cancelDownload()
        case .downloaded:
            break
        }
    }
    
    func configureDarkViewAppearance() {
        
        if isModelDownloaded() || coreMLModel.coreMLType == .normal {
            DispatchQueue.main.async {
                self.darkView.alpha = 0
                self.disableDonwloadButton()
            }
        } else {
            DispatchQueue.main.async {
                self.darkView.alpha = 1
                self.enableDownloadButton()
                self.getModelButton.setTitle("Get", for: .normal)
            }
        }
    }
    
    func animateDarkViewDisappearance() {
        
        getModelButton.setTitle("✓")
        getModelButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 0.6, animations: {
                self.darkView.alpha = 0
            })
        }
    }
    
    func enableDownloadButton() {
        getModelButton.isUserInteractionEnabled = true
        progressButton.startDownloadButton.isUserInteractionEnabled = true
        progressButton.stopDownloadButton.stopButton.isUserInteractionEnabled = true
        progressButton.downloadedButton.isUserInteractionEnabled = true
    }
    
    func disableDonwloadButton() {
        getModelButton.isUserInteractionEnabled = false
        progressButton.startDownloadButton.isUserInteractionEnabled = false
        progressButton.stopDownloadButton.stopButton.isUserInteractionEnabled = false
        progressButton.downloadedButton.isUserInteractionEnabled = false
    }
    
    func animteButtonToProgress() {
        
        disableDonwloadButton()
        
        DispatchQueue.main.async {
            
            self.progressButton.alpha = 0
            self.progressButton.state = .pending
            self.getModelButtonBackgroundView.addSubview(self.progressButton)
            
            let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
                self.getModelButtonBackgroundView.frame.origin.x += 25
                self.getModelButtonBackgroundView.frame.size.width -= 50
                self.getModelButtonBackgroundView.backgroundColor = .clear
                self.getModelButton.alpha = 0
                self.progressButton.alpha = 1
            })
            animator.startAnimation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.enableDownloadButton()
        }
    }
    
    func animateProgressToButton() {
        
        disableDonwloadButton()
        
        DispatchQueue.main.async {
            
            let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
                self.getModelButtonBackgroundView.frame.origin.x -= 25
                self.getModelButtonBackgroundView.frame.size.width += 50
                self.getModelButtonBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7018595951)
                self.getModelButton.alpha = 1
                self.progressButton.alpha = 0
            })
            animator.startAnimation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressButton.removeFromSuperview()
            self.enableDownloadButton()
        }
    }
    
}


