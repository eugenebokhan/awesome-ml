//
//  MobileNetModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let mobileNetModel = CoreMLModel(name: "MobileNet", machineLearningModelType: .mobileNet, shortDescription: "The network from the paper 'MobileNets: Efficient Convolutional Neural Networks for Mobile Vision Applications', trained on the ImageNet dataset.", detailedDescriptionURL: Bundle.main.url(forResource: "MobileNet", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "MobileNet Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/MobileNet.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1cRBSU69LRPeY-5tzfsEIqCBPAoqyoZwr")!)
