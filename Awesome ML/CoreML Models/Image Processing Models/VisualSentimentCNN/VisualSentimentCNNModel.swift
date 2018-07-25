//
//  VisualSentimentCNNModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let visualSentimentCNNModel = CoreMLModel(name: "VisualSentimentCNN", machineLearningModelType: .visualSentimentCNN, shortDescription: "Fine-tuning CNNs for Visual Sentiment Prediction.", detailedDescriptionURL: Bundle.main.url(forResource: "VisualSentimentCNN", withExtension: "md")!, coverImage: #imageLiteral(resourceName: "VisualSentimentCNN Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/VisualSentimentCNN.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1r1fV8KfpNhM6IcxRGdrm4fRdiWsmULS_")!)
