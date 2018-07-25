//
//  MobileOpenPoseModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let mobileOpenPoseModel = CoreMLModel.init(name: "MobileOpenPose", machineLearningModelType: .mobileOpenPose, shortDescription: "First real-time multi-person system to jointly detect human body keypoints", detailedDescriptionURL: Bundle.main.url(forResource: "OpenPose", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "MobileOpenPose Cover"), inputWidth: 368, inputHeight: 368, remoteURL: URL(string: "https://github.com/eugenebokhan/iOS-OpenPose/raw/master/iOSOpenPose/iOSOpenPose/CoreML/MobileOpenPose.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1EycXgXuoMCBr9AEGapoBHpPVLV6dmQQF")!)

