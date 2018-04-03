//
//  GenderNetModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let genderNetModel = CoreMLModel(name: "GenderNet", coreMLType: .genderNet, author: "Gil Levi and Tal Hassner", modelDescription: "Gender Classification using Convolutional Neural Networks.", image: #imageLiteral(resourceName: "GenderNet Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/GenderNet.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1A1KQcLWRphMsr09VqV-Ql6OWgEDsUZl-")!, license: "MIT")
