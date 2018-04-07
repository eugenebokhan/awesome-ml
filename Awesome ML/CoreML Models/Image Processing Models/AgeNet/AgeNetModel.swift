//
//  AgeNetModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let ageNetModel = CoreMLModel(name: "AgeNet", coreMLType: .ageNet, shortDescription: "Age Classification using Convolutional Neural Networks", detailedDescription: "# Authors and Contributors \n Gil Levi and Tal Hassner, Age and Gender Classification using Convolutional Neural Networks, IEEE Workshop on Analysis and Modeling of Faces and Gestures (AMFG), at the IEEE Conf. on Computer Vision and Pattern Recognition (CVPR), Boston, June 2015 \n # Abstract \n Automatic age and gender classification has become relevant to an increasing amount of applications, particularly since the rise of social platforms and social media. Nevertheless, performance of existing methods on real-world images is still significantly lacking, especially when compared to the tremendous leaps in performance recently reported for the related task of face recognition. In this paper we show that by learning representations through the use of deep-convolutional neural networks (CNN), a significant increase in performance can be obtained on these tasks. To this end, we propose a simple convolutional net architecture that can be used even when the amount of learning data is limited. We evaluate our method on the recent Adience benchmark for age and gender estimation and show it to dramatically outperform current state-of-the-art methods. \n ## Input  \n A color (227x227) image. \n ## Output \n The most likely age, for the given input. \n ## License \n Public Domain", image: #imageLiteral(resourceName: "AgeNet Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/AgeNet.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1XDb_jxPkKa0e6-GnQ3RDOx9q3CkdDMAh")!, license: "MIT")
