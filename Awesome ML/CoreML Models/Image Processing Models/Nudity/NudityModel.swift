//
//  NudityModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let nudityModel = CoreMLModel(name: "Nudity", machineLearningModelType: .nudity, shortDescription: "Classifies an image either as NSFW (nude) or SFW (not nude).", detailedDescriptionURL: Bundle.main.url(forResource: "Nudity", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "Nudity Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/Nudity.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1HeJhs6sjsguqDbbtn2Mvt8e7NW5Z7fVj")!)
