//
//  VisualSentimentCNNModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let visualSentimentCNNModel = CoreMLModel(name: "VisualSentimentCNN", coreMLType: .visualSentimentCNN, author: "Fine-tuning CNNs for Visual Sentiment Prediction.", modelDescription: "# Authors and Contributors \n Authors and contibutors: mage Processing Group - BarcelonaTECH - UPC. \n # Description \n Visual multimedia have become an inseparable part of our digital social lives, and they often capture moments tied with deep affections. Automated visual sentiment analysis tools can provide a means of extracting the rich feelings and latent dispositions embedded in these media. In this work, we explore how Convolutional Neural Networks (CNNs), a now de facto computational machine learning tool particularly in the area of Computer Vision, can be specifically applied to the task of visual sentiment prediction. We accomplish this through fine-tuning experiments using a state-of-the-art CNN and via rigorous architecture analysis, we present several modifications that lead to accuracy improvements over prior art on a dataset of images from a popular social media platform. We additionally present visualizations of local patterns that the network learned to associate with image sentiment for insight into how visual positivity (or negativity) is perceived by the model. \n ## Input  \n A color (227x227) image. \n ## Output \n Most likely image category. \n ## License \n Public Domain.", image: #imageLiteral(resourceName: "VisualSentimentCNN Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/VisualSentimentCNN.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1r1fV8KfpNhM6IcxRGdrm4fRdiWsmULS_")!, license: "MIT")
