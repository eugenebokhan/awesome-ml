//
//  FlickrStyleModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let flickrStyleModel = CoreMLModel(name: "FlickrStyle", machineLearningModelType: .flickrStyle, shortDescription: "Finetuning CaffeNet on Flickr Style", detailedDescriptionURL: Bundle.main.url(forResource: "FlickrStyle", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "Flicr Style Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/FlickrStyle.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1X6F3laayxFEiadTd-pvNR6odWeWKZ0-6")!)
