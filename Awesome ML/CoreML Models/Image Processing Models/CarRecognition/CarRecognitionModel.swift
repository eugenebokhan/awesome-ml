//
//  CarRecognitionModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let carRecognitionModel = CoreMLModel(name: "CarRecognition", machineLearningModelType: .carRecognition, shortDescription: "Predict the brand & model of a car.", detailedDescriptionURL: Bundle.main.url(forResource: "CarRecognition", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "Car Recognition Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/CarRecognition.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1YUIS8ATJ_Kt1VHJitDZuPzr_Wn6IPzs6")!)
