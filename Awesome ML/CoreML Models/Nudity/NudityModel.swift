//
//  NudityModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let nudityModel = CoreMLModel(name: "Nudity", coreMLType: .nudity, author: "Classifies an image either as NSFW (nude) or SFW (not nude).", modelDescription: "# Authors and Contributors \n Author: Philipp Gabriel. \n # Description \n Detecting offensive / adult images is an important problem which researchers have tackled for decades. With the evolution of computer vision and deep learning the algorithms have matured and we are now able to classify an image as not suitable for work with greater precision. Defining NSFW material is subjective and the task of identifying these images is non-trivial. Moreover, what may be objectionable in one context can be suitable in another. For this reason, the model we describe below focuses only on one type of NSFW content: pornographic images. The identification of NSFW sketches, cartoons, text, images of graphic violence, or other types of unsuitable content is not addressed with this model. Since images and user generated content dominate the internet today, filtering nudity and other not suitable for work images becomes an important problem. In this repository we opensource a Caffe deep neural network for preliminary filtering of NSFW images. \n ## Input  \n A color (224x224) image. \n ## Output \n NSFW or SFW. \n ## License \n Public Domain.", image: #imageLiteral(resourceName: "Nudity Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/Nudity.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1HeJhs6sjsguqDbbtn2Mvt8e7NW5Z7fVj")!, license: "BSD-2")
