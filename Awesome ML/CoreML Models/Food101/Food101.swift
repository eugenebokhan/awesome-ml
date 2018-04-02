//
//  Food101.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class Food101Input : MLFeatureProvider {
    
    /// Image of a food as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high
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
class Food101Output : MLFeatureProvider {
    
    /// Confidence and label of predicted food as dictionary of strings to doubles
    let foodConfidence: [String : Double]
    
    /// Label of predicted food as string value
    let classLabel: String
    
    var featureNames: Set<String> {
        get {
            return ["foodConfidence", "classLabel"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "foodConfidence") {
            return try! MLFeatureValue(dictionary: foodConfidence as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    init(foodConfidence: [String : Double], classLabel: String) {
        self.foodConfidence = foodConfidence
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class Food101 {
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
        let bundle = Bundle(for: Food101.self)
        let assetPath = bundle.url(forResource: "Food101", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as Food101Input
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as Food101Output
     */
    func prediction(input: Food101Input) throws -> Food101Output {
        let outFeatures = try model.prediction(from: input)
        let result = Food101Output(foodConfidence: outFeatures.featureValue(for: "foodConfidence")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - image: Image of a food as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as Food101Output
     */
    func prediction(image: CVPixelBuffer) throws -> Food101Output {
        let input_ = Food101Input(image: image)
        return try self.prediction(input: input_)
    }
}

