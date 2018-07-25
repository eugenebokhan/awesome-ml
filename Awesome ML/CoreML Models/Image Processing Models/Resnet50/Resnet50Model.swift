//
//  Resnet50Model.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let resnet50Model = CoreMLModel(name: "Resnet50", machineLearningModelType: .resnet50, shortDescription: "Detects the dominant objects present in an image from a set of 1000 categories such as trees, animals, food, vehicles, person etc. The top-5 error from the original publication is 7.8%.", detailedDescriptionURL: Bundle.main.url(forResource: "Resnet50", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "ResNet50 Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/Resnet50.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1LYQrOpiKEUpTvquFoHawLUmYEgS751CJ")!)
