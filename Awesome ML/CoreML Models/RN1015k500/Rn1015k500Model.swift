//
//  Rn1015k500Model.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let rn1015k500Model = CoreMLModel(name: "RN1015k500", coreMLType: .rn1015k500, author: "Jaeyoung Choi and Kevin Li", modelDescription: "Predict the location where a picture was taken.", image: #imageLiteral(resourceName: "RN1015k500 Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/RN1015k500.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1H7XFfbrwMarY407DLVtYn9Kl-t0opxAy")!, license: "MIT")
