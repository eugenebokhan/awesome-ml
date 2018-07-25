//
//  Oxford102Model.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let oxford102Model = CoreMLModel(name: "Oxford102", machineLearningModelType: .oxford102, shortDescription: "Classifying images in the Oxford 102 flower dataset with CNNs", detailedDescriptionURL: Bundle.main.url(forResource: "Oxford102", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "Oxford102 Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/Oxford102.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1pLNiwwj2vpi4uZ8zhDCJba9DMo8vlZjM")!)
