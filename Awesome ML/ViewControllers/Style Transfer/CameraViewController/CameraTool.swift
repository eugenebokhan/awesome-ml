//
//  CameraTool.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit
import AVFoundation

class CameraTool: NSObject {
    
    static func resizeImage(_ image: UIImage, newWidthX: CGFloat , newHeightX: CGFloat) -> UIImage {
        var newWidth = newWidthX
        var newHeight = newHeightX
        if (image.size.width < newWidth){
            newWidth = image.size.width
            newHeight = image.size.width
        }
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    static func cropImage(_ original: UIImage, previewLayer: AVCaptureVideoPreviewLayer) -> UIImage? {
        
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
    
    static func filteredWithBrightness(_ image: UIImage, brightnessT: Float) -> UIImage? {
        
        guard let ciimage = CIImage(image: image) else {
            return nil
        }
        let filter = CIFilter(name: "CIExposureAdjust", parameters: [kCIInputImageKey: ciimage])
        filter?.setDefaults()
        let brightness: CGFloat = CGFloat(2 * brightnessT)
        filter?.setValue(brightness, forKey: kCIInputEVKey)
        
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer: (false)])
        let outputImage = filter?.outputImage
        let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let result = UIImage(cgImage: cgImage!)
        return result
    }
    
    
    static func filteredWithSaturation(_ image: UIImage, Saturation: Float) -> UIImage? {
        guard let ciimage = CIImage(image: image) else {
            return nil
        }
        let filter = CIFilter.init(name: "CIColorControls")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        filter?.setValue(Saturation, forKey: kCIInputSaturationKey)
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let cgimage = CIContext.init(options: nil).createCGImage(result, from: result.extent)
        let image = UIImage.init(cgImage: cgimage!)
        return image
    }
    
    
    static func filteredWithContrast(_ image: UIImage, contrastT: Float) -> UIImage? {
        guard let beginImage = CIImage(image: image) else {
            return nil
        }
        let parameters = [kCIInputImageKey      : beginImage,
                          kCIInputContrastKey   : contrastT
            ] as [String : Any]
        
        let outputImage = CIFilter(name: "CIColorControls",
                                   parameters: parameters)?.outputImage
        
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer: (false)])
        let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let result = UIImage(cgImage: cgImage!)
        return result
    }
    
}
