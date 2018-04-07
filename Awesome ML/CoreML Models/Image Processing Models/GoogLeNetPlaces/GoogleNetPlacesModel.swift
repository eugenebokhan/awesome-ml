//
//  GoogLeNetPlacesModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let googLeNetPlacesModel = CoreMLModel(name: "Google Net Places", coreMLType: .googleNetPlaces, shortDescription: "Detects the scene of an image from 205 categories such as airport, bedroom, forest, coast etc.", detailedDescription: "# Authors and Contributors \n B. Zhou, A. Lapedriza, J. Xiao, A. Torralba, and A. Oliva. \n # Description \n Scene recognition is one of the hallmark tasks of computer vision, allowing defining a context for object recognition. Here we introduce a new scene-centric database called Places, with 205 scene categories and 2.5 millions of images with a category label. Using convolutional neural network (CNN), we learn deep scene features for scene recognition tasks, and establish new state-of-the-art performances on scene-centric benchmarks.. \n ## Input  \n A color (224x224) image. \n ## Output \n Most likely scene label. \n ## License \n Public Domain.", image: #imageLiteral(resourceName: "GoogleNetPlaces Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/GoogLeNetPlaces.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1eR5Y2NmHELjaVPUt0M7M659D1GUD5y8g")!, license: "MIT")
