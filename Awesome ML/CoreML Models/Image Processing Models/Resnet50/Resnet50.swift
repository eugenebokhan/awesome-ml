//
//  Resnet50.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class Resnet50Input : MLFeatureProvider {
    
    /// Input image of scene to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
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
class Resnet50Output : MLFeatureProvider {
    
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
class Resnet50 {
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
        let bundle = Bundle(for: Resnet50.self)
        let assetPath = bundle.url(forResource: "Resnet50", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as Resnet50Input
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as Resnet50Output
     */
    func prediction(input: Resnet50Input) throws -> Resnet50Output {
        let outFeatures = try model.prediction(from: input)
        let result = Resnet50Output(classLabelProbs: outFeatures.featureValue(for: "classLabelProbs")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - image: Input image of scene to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as Resnet50Output
     */
    func prediction(image: CVPixelBuffer) throws -> Resnet50Output {
        let input_ = Resnet50Input(image: image)
        return try self.prediction(input: input_)
    }
}

