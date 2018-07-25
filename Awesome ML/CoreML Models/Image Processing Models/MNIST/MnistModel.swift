//
//  MnistModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let mnistModel = CoreMLModel(name: "MNIST", machineLearningModelType: .mnist, shortDescription: "Predicts a handwritten digit.", detailedDescriptionURL: Bundle.main.url(forResource: "MNIST", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "MNIST Cover"), inputWidth: 28, inputHeight: 28, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/MNIST.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1F09FHXEEHVLbBvH8cL9d2BgutEK9K_MR")!)
