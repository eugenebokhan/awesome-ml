//
//  MobileNet.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class MobileNetInput : MLFeatureProvider {
    
    /// Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
    var data: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["data"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "data") {
            return MLFeatureValue(pixelBuffer: data)
        }
        return nil
    }
    
    init(data: CVPixelBuffer) {
        self.data = data
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class MobileNetOutput : MLFeatureProvider {
    
    /// Probability of each category as dictionary of strings to doubles
    let prob: [String : Double]
    
    /// Most likely image category as string value
    let classLabel: String
    
    var featureNames: Set<String> {
        get {
            return ["prob", "classLabel"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "prob") {
            return try! MLFeatureValue(dictionary: prob as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    init(prob: [String : Double], classLabel: String) {
        self.prob = prob
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class MobileNet {
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
        let bundle = Bundle(for: MobileNet.self)
        let assetPath = bundle.url(forResource: "MobileNet", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as MobileNetInput
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as MobileNetOutput
     */
    func prediction(input: MobileNetInput) throws -> MobileNetOutput {
        let outFeatures = try model.prediction(from: input)
        let result = MobileNetOutput(prob: outFeatures.featureValue(for: "prob")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - data: Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as MobileNetOutput
     */
    func prediction(data: CVPixelBuffer) throws -> MobileNetOutput {
        let input_ = MobileNetInput(data: data)
        return try self.prediction(input: input_)
    }
}

