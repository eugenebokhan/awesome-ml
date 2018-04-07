//
//  MobileOpenPose.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class MobileOpenPoseInput : MLFeatureProvider {
    
    /// image as color (kCVPixelFormatType_32BGRA) image buffer, 368 pixels wide by 368 pixels high
    var image: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class MobileOpenPoseOutput : MLFeatureProvider {
    
    /// net_output as 57 x 46 x 46 3-dimensional array of doubles
    let net_output: MLMultiArray
    
    var featureNames: Set<String> {
        get {
            return ["net_output"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "net_output") {
            return MLFeatureValue(multiArray: net_output)
        }
        return nil
    }
    
    init(net_output: MLMultiArray) {
        self.net_output = net_output
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class MobileOpenPose {
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
        let bundle = Bundle(for: MobileOpenPose.self)
        let assetPath = bundle.url(forResource: "MobileOpenPose", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as MobileOpenPoseInput
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as MobileOpenPoseOutput
     */
    func prediction(input: MobileOpenPoseInput) throws -> MobileOpenPoseOutput {
        let outFeatures = try model.prediction(from: input)
        let result = MobileOpenPoseOutput(net_output: outFeatures.featureValue(for: "net_output")!.multiArrayValue!)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - image as color (kCVPixelFormatType_32BGRA) image buffer, 368 pixels wide by 368 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as MobileOpenPoseOutput
     */
    func prediction(image: CVPixelBuffer) throws -> MobileOpenPoseOutput {
        let input_ = MobileOpenPoseInput(image: image)
        return try self.prediction(input: input_)
    }
}

