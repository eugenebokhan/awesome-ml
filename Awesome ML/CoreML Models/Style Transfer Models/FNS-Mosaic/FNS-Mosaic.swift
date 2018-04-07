//
//  FNSMosaic.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/6/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class FNSMosaicInput : MLFeatureProvider {
    
    /// Image to stylize as color (kCVPixelFormatType_32BGRA) image buffer, 720 pixels wide by 720 pixels high
    var inputImage: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["inputImage"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "inputImage") {
            return MLFeatureValue(pixelBuffer: inputImage)
        }
        return nil
    }
    
    init(inputImage: CVPixelBuffer) {
        self.inputImage = inputImage
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class FNSMosaicOutput : MLFeatureProvider {
    
    /// Stylized image as color (kCVPixelFormatType_32BGRA) image buffer, 720 pixels wide by 720 pixels high
    let outputImage: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["outputImage"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "outputImage") {
            return MLFeatureValue(pixelBuffer: outputImage)
        }
        return nil
    }
    
    init(outputImage: CVPixelBuffer) {
        self.outputImage = outputImage
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class FNSMosaic {
    var model: MLModel
    
    /**
     Construct a model with explicit path to mlmodel file
     - parameters:
     - url: the file url of the model
     - throws: an NSError object that describes the problem
     */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }
    
    /// Construct a model that automatically loads the model from the app's bundle
    convenience init() {
        let bundle = Bundle(for: FNSMosaic.self)
        let assetPath = bundle.url(forResource: "FNSMosaic", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as FNSMosaicInput
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as FNSMosaicOutput
     */
    func prediction(input: FNSMosaicInput) throws -> FNSMosaicOutput {
        let outFeatures = try model.prediction(from: input)
        let result = FNSMosaicOutput(outputImage: outFeatures.featureValue(for: "outputImage")!.imageBufferValue!)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - inputImage: Image to stylize as color (kCVPixelFormatType_32BGRA) image buffer, 720 pixels wide by 720 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as FNSMosaicOutput
     */
    func prediction(inputImage: CVPixelBuffer) throws -> FNSMosaicOutput {
        let input_ = FNSMosaicInput(inputImage: inputImage)
        return try self.prediction(input: input_)
    }
}

