//
//  AgeNetModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let ageNetModel = CoreMLModel(name: "AgeNet", machineLearningModelType: .ageNet, shortDescription: "Age Classification using Convolutional Neural Networks", detailedDescriptionURL: Bundle.main.url(forResource: "AgeNet", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "AgeNet Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/AgeNet.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1XDb_jxPkKa0e6-GnQ3RDOx9q3CkdDMAh")!)
