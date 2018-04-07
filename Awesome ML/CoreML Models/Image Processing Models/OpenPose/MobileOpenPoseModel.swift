//
//  MobileOpenPoseModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let mobileOpenPoseModel = CoreMLModel.init(name: "MobileOpenPose", coreMLType: .mobileOpenPose, shortDescription: "First real-time multi-person system to jointly detect human body keypoints", detailedDescription: "# Authors and Contributors\nOpenPose is authored by Gines Hidalgo, Zhe Cao, Tomas Simon, Shih-En Wei, Hanbyul Joo, and Yaser Sheikh. Currently, it is being maintained by Gines Hidalgo, Bikramjot Hanzra, and Yaadhav Raaj. The original CVPR 2017 repo includes Matlab and Python versions, as well as the training code. The body pose estimation work is based on the original ECCV 2016 demo.\nIn addition, OpenPose would not be possible without the CMU Panoptic Studio dataset.\n\n # Functionality \n\n **Real-time multi-person keypoint detection**.\n**15 or 18-keypoint body estimation**. **Running time invariant to number of detected people**.\n**2x21-keypoint hand** estimation. Currently, **running time depends** on **number of detected people**.\n**70-keypoint face** estimation. Currently, **running time depends** on **number of detected people**.\n**Input**: Image, video, webcam, and IP camera. Included C++ demos to add your custom input.\n**Output**: Basic image + keypoint display/saving (PNG, JPG, AVI, ...), keypoint saving (JSON, XML, YML, ...), and/or keypoints as array class.\n**Available**: command-line demo, C++ wrapper, and C++ API.\n**OS**: Ubuntu (14, 16), Windows (8, 10), Nvidia TX2, iOS.\n\n## License\nOpenPose is freely available for free non-commercial use, and may be redistributed under these conditions.", image: #imageLiteral(resourceName: "MobileOpenPose Cover"), inputWidth: 368, inputHeight: 368, remoteURL: URL(string: "https://github.com/eugenebokhan/iOS-OpenPose/raw/master/iOSOpenPose/iOSOpenPose/CoreML/MobileOpenPose.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1EycXgXuoMCBr9AEGapoBHpPVLV6dmQQF")!, license: "MIT")

