//
//  FNS-RainPrincess.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/8/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class FNSRainPrincessInput : MLFeatureProvider {
    
    /// img_placeholder__0 as color (kCVPixelFormatType_32BGRA) image buffer, 883 pixels wide by 720 pixels high
    var img_placeholder__0: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["img_placeholder__0"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "img_placeholder__0") {
            return MLFeatureValue(pixelBuffer: img_placeholder__0)
        }
        return nil
    }
    
    init(img_placeholder__0: CVPixelBuffer) {
        self.img_placeholder__0 = img_placeholder__0
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class FNSRainPrincessOutput : MLFeatureProvider {
    
    /// add_37__0 as color (kCVPixelFormatType_32BGRA) image buffer, 884 pixels wide by 720 pixels high
    let add_37__0: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["add_37__0"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "add_37__0") {
            return MLFeatureValue(pixelBuffer: add_37__0)
        }
        return nil
    }
    
    init(add_37__0: CVPixelBuffer) {
        self.add_37__0 = add_37__0
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class FNSRainPrincess {
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
        let bundle = Bundle(for: rain_princess.self)
        let assetPath = bundle.url(forResource: "rain_princess", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as rain_princessInput
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as rain_princessOutput
     */
    func prediction(input: FNSRainPrincessInput) throws -> FNSRainPrincessOutput {
        let outFeatures = try model.prediction(from: input)
        let result = FNSRainPrincessOutput(add_37__0: outFeatures.featureValue(for: "add_37__0")!.imageBufferValue!)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - img_placeholder__0 as color (kCVPixelFormatType_32BGRA) image buffer, 883 pixels wide by 720 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as rain_princessOutput
     */
    func prediction(img_placeholder__0: CVPixelBuffer) throws -> FNSRainPrincessOutput {
        let input_ = FNSRainPrincessInput(img_placeholder__0: img_placeholder__0)
        return try self.prediction(input: input_)
    }
}

