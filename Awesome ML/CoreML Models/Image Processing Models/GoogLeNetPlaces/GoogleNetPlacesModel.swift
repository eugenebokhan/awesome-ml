//
//  GoogLeNetPlacesModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let googLeNetPlacesModel = CoreMLModel(name: "Google Net Places", machineLearningModelType: .googleNetPlaces, shortDescription: "Detects the scene of an image from 205 categories such as airport, bedroom, forest, coast etc.", detailedDescriptionURL: Bundle.main.url(forResource: "GoogleNetPlaces", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "GoogleNetPlaces Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/GoogLeNetPlaces.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1eR5Y2NmHELjaVPUt0M7M659D1GUD5y8g")!)
