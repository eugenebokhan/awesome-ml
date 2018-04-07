//
//  TinyYOLOModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let tinyYOLOModel = CoreMLModel(name: "Tiny YOLO", coreMLType: .tinyYOLO, shortDescription: "Recognize what the objects are inside a given image and also where they are in the image.", detailedDescription: "# Authors and Contributors \n The Tiny YOLO network from the paper \'YOLO9000: Better, Faster, Stronger\' (2016), arXiv:1612.08242. Original paper: Joseph Redmon, Ali Farhadi. \n # Functionality \n YOLO actually looks at the image just once (hence its name: You Only Look Once) but in a clever way. YOLO divides up the image into a grid of 13 by 13 cells. Each of these cells is responsible for predicting 5 bounding boxes. A bounding box describes the rectangle that encloses an object. YOLO also outputs a confidence score that tells us how certain it is that the predicted bounding box actually encloses some object. This score doesn’t say anything about what kind of object is in the box, just if the shape of the box is any good. For each bounding box, the cell also predicts a class. This works just like a classifier: it gives a probability distribution over all the possible classes. The confidence score for the bounding box and the class prediction are combined into one final score that tells us the probability that this bounding box contains a specific type of object. \n ## Input  \n A color (416x416) image. \n ## Output \n The 13x13 grid with the bounding box data. \n ## License \n Public Domain", image: #imageLiteral(resourceName: "TinyYOLO Cover"), inputWidth: 416, inputHeight: 416, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/TinyYOLO.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1n8pL6D2w7W7KkrxmaPycCXQtEOoKSIkO")!, license: "MIT")
