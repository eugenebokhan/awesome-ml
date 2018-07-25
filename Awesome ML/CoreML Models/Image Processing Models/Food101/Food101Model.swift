//
//  Food101Model.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let food101Model = CoreMLModel(name: "Food101", machineLearningModelType: .food101, shortDescription: "This model takes a picture of a food and predicts its name", detailedDescriptionURL: Bundle.main.url(forResource: "Food101", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "Food101 Cover"), inputWidth: 299, inputHeight: 299, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/Food101.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1DYpcEYTxKO7KJiWRwDe4KVIGvUxyVHpe")!)
