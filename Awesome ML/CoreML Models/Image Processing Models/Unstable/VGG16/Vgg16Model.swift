//
//  Vgg16Model.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let vgg16Model = CoreMLModel(name: "VGG16", coreMLType: .vgg16, shortDescription: "Original Paper: Karen Simonyan & Andrew Zisserman. Keras Implementation: François Chollet", detailedDescription: "Detects the dominant objects present in an image from a set of 1000 categories such as trees, animals, food, vehicles, person etc. The top-5 error from the original publication is 7.4%.", image: #imageLiteral(resourceName: "VGG16 Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/VGG16.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=11RTPwPa01MaSryHCMpFZdeIfTad5j6YE")!, license: "Creative Commons Attribution 4.0 International(CC BY 4.0)")
