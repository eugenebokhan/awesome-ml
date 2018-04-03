//
//  MnistModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let mnistModel = CoreMLModel(name: "MNIST", coreMLType: .mnist, author: "Predicts a handwritten digit.", modelDescription: "# Authors and Contributors \n Author: Philipp Gabriel. \n # Description \n The MNIST database of handwritten digits, available from this page, has a training set of 60,000 examples, and a test set of 10,000 examples. It is a subset of a larger set available from NIST. The digits have been size-normalized and centered in a fixed-size image. It is a good database for people who want to try learning techniques and pattern recognition methods on real-world data while spending minimal efforts on preprocessing and formatting. \n ## Input  \n A greyscale (28x28) image. \n ## Output \n Most likely image category. \n ## License \n Public Domain.", image: #imageLiteral(resourceName: "MNIST Cover"), inputWidth: 28, inputHeight: 28, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/MNIST.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1F09FHXEEHVLbBvH8cL9d2BgutEK9K_MR")!, license: "MIT")
