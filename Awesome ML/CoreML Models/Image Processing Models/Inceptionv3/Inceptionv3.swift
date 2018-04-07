//
//  Inceptionv3.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class Inceptionv3Input : MLFeatureProvider {
    
    /// Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high
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
class Inceptionv3Output : MLFeatureProvider {
    
    /// Probability of each category as dictionary of strings to doubles
    let classLabelProbs: [String : Double]
    
    /// Most likely image category as string value
    let classLabel: String
    
    var featureNames: Set<String> {
        get {
            return ["classLabelProbs", "classLabel"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "classLabelProbs") {
            return try! MLFeatureValue(dictionary: classLabelProbs as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    init(classLabelProbs: [String : Double], classLabel: String) {
        self.classLabelProbs = classLabelProbs
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class Inceptionv3 {
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
        let bundle = Bundle(for: Inceptionv3.self)
        let assetPath = bundle.url(forResource: "Inceptionv3", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as Inceptionv3Input
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as Inceptionv3Output
     */
    func prediction(input: Inceptionv3Input) throws -> Inceptionv3Output {
        let outFeatures = try model.prediction(from: input)
        let result = Inceptionv3Output(classLabelProbs: outFeatures.featureValue(for: "classLabelProbs")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - image: Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as Inceptionv3Output
     */
    func prediction(image: CVPixelBuffer) throws -> Inceptionv3Output {
        let input_ = Inceptionv3Input(image: image)
        return try self.prediction(input: input_)
    }
}

