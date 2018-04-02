//
//  RN1015k500.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class RN1015k500Input : MLFeatureProvider {
    
    /// data as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
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
class RN1015k500Output : MLFeatureProvider {
    
    /// softmax_output as dictionary of strings to doubles
    let softmax_output: [String : Double]
    
    /// classLabel as string value
    let classLabel: String
    
    var featureNames: Set<String> {
        get {
            return ["softmax_output", "classLabel"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "softmax_output") {
            return try! MLFeatureValue(dictionary: softmax_output as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    init(softmax_output: [String : Double], classLabel: String) {
        self.softmax_output = softmax_output
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class RN1015k500 {
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
        let bundle = Bundle(for: RN1015k500.self)
        let assetPath = bundle.url(forResource: "RN1015k500", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as RN1015k500Input
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as RN1015k500Output
     */
    func prediction(input: RN1015k500Input) throws -> RN1015k500Output {
        let outFeatures = try model.prediction(from: input)
        let result = RN1015k500Output(softmax_output: outFeatures.featureValue(for: "softmax_output")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - data as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as RN1015k500Output
     */
    func prediction(data: CVPixelBuffer) throws -> RN1015k500Output {
        let input_ = RN1015k500Input(data: data)
        return try self.prediction(input: input_)
    }
}

