//
//  TinyYOLOModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let tinyYOLOModel = CoreMLModel(name: "Tiny YOLO", machineLearningModelType: .tinyYOLO, shortDescription: "Recognize what the objects are inside a given image and also where they are in the image.", detailedDescriptionURL: Bundle.main.url(forResource: "TinyYOLO", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "TinyYOLO Cover"), inputWidth: 416, inputHeight: 416, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/TinyYOLO.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1n8pL6D2w7W7KkrxmaPycCXQtEOoKSIkO")!)
