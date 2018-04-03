//
//  GoogLeNetPlaces.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GoogLeNetPlacesInput : MLFeatureProvider {
    
    /// Input image of scene to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
    var sceneImage: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["sceneImage"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "sceneImage") {
            return MLFeatureValue(pixelBuffer: sceneImage)
        }
        return nil
    }
    
    init(sceneImage: CVPixelBuffer) {
        self.sceneImage = sceneImage
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GoogLeNetPlacesOutput : MLFeatureProvider {
    
    /// Probability of each scene as dictionary of strings to doubles
    let sceneLabelProbs: [String : Double]
    
    /// Most likely scene label as string value
    let sceneLabel: String
    
    var featureNames: Set<String> {
        get {
            return ["sceneLabelProbs", "sceneLabel"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "sceneLabelProbs") {
            return try! MLFeatureValue(dictionary: sceneLabelProbs as [NSObject : NSNumber])
        }
        if (featureName == "sceneLabel") {
            return MLFeatureValue(string: sceneLabel)
        }
        return nil
    }
    
    init(sceneLabelProbs: [String : Double], sceneLabel: String) {
        self.sceneLabelProbs = sceneLabelProbs
        self.sceneLabel = sceneLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GoogLeNetPlaces {
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
        let bundle = Bundle(for: GoogLeNetPlaces.self)
        let assetPath = bundle.url(forResource: "GoogLeNetPlaces", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as GoogLeNetPlacesInput
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as GoogLeNetPlacesOutput
     */
    func prediction(input: GoogLeNetPlacesInput) throws -> GoogLeNetPlacesOutput {
        let outFeatures = try model.prediction(from: input)
        let result = GoogLeNetPlacesOutput(sceneLabelProbs: outFeatures.featureValue(for: "sceneLabelProbs")!.dictionaryValue as! [String : Double], sceneLabel: outFeatures.featureValue(for: "sceneLabel")!.stringValue)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - sceneImage: Input image of scene to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as GoogLeNetPlacesOutput
     */
    func prediction(sceneImage: CVPixelBuffer) throws -> GoogLeNetPlacesOutput {
        let input_ = GoogLeNetPlacesInput(sceneImage: sceneImage)
        return try self.prediction(input: input_)
    }
}

