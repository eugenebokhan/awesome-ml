//
//  FNSMosaicModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/6/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let fnsMosaicModel = CoreMLModel(name: "FNS-Mosaic", machineLearningModelType: .fnsMosaic, shortDescription: "Feedforward style transfer", detailedDescriptionURL: Bundle.main.url(forResource: "FNS", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "FNS-Mosaic Cover"), inputWidth: 720, inputHeight: 720, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/FNS-Mosaic.mlmodel")!, remoteZipURL: nil)


