//
//  Inceptionv3Model.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let inceptionv3Model = CoreMLModel(name: "Inceptionv3", machineLearningModelType: .inceptionv3, shortDescription: "Detects the dominant objects present in an image from a set of 1000 categories such as trees, animals, food, vehicles, person etc. The top-5 error from the original publication is 5.6%.", detailedDescriptionURL: Bundle.main.url(forResource: "InceptionV3", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "Inception3 Cover"), inputWidth: 299, inputHeight: 299, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/Inceptionv3.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1JDplpgST9mTdGhVuQx-8Se8MP8VHXio_")!)
