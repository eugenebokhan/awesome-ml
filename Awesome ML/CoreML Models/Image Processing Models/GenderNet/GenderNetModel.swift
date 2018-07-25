//
//  GenderNetModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let genderNetModel = CoreMLModel(name: "GenderNet", machineLearningModelType: .genderNet, shortDescription: "Gender Classification using Convolutional Neural Networks.", detailedDescriptionURL: Bundle.main.url(forResource: "GenderNet", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "GenderNet Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/GenderNet.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1A1KQcLWRphMsr09VqV-Ql6OWgEDsUZl-")!)
