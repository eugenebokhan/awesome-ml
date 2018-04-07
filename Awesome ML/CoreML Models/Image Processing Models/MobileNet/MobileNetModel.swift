//
//  MobileNetModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let mobileNetModel = CoreMLModel(name: "MobileNet", coreMLType: .mobileNet, shortDescription: "The network from the paper 'MobileNets: Efficient Convolutional Neural Networks for Mobile Vision Applications', trained on the ImageNet dataset.", detailedDescription: "# Authors and Contributors \n Authors and contibutors: The network from the paper \'MobileNets: Efficient Convolutional Neural Networks for Mobile Vision Applications\', trained on the ImageNet dataset. \n # Description \n MobileNets are based on a streamlined architecture that uses depth-wise separable convolutions to build light weight deep neural networks. We introduce two simple global hyper-parameters that efficiently trade off between latency and accuracy. These hyper-parameters allow the model builder to choose the right sized model for their application based on the constraints of the problem. We present extensive experiments on resource and accuracy tradeoffs and show strong performance compared to other popular models on ImageNet classification. We then demonstrate the effectiveness of MobileNets across a wide range of applications and use cases including object detection, finegrain classification, face attributes and large scale geo-localization. \n ## Input  \n A color (224x224) image. \n ## Output \n Most likely image category. \n ## License \n Public Domain.", image: #imageLiteral(resourceName: "MobileNet Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/MobileNet.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1cRBSU69LRPeY-5tzfsEIqCBPAoqyoZwr")!, license: "MIT")
