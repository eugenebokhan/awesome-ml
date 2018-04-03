//
//  CarRecognitionModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let carRecognitionModel = CoreMLModel(name: "CarRecognition", coreMLType: .carRecognition, author: "Predict the brand & model of a car.", modelDescription: "# Authors and Contributors \n This dataset is presented in our CVPR 2015 paper, Linjie Yang, Ping Luo, Chen Change Loy, Xiaoou Tang. A Large-Scale Car Dataset for Fine-Grained Categorization and \n  Verification, In Computer Vision and Pattern Recognition (CVPR), 2015. \n # Functionality \n The Comprehensive Cars (CompCars) dataset contains data from two scenarios, including images from web-nature and surveillance-nature. The web-nature data contains 163 car makes with 1,716 car models. There are a total of 136,726 images capturing the entire cars and 27,618 images capturing the car parts. The full car images are labeled with bounding boxes and viewpoints. Each car model is labeled with five attributes, including maximum speed, displacement, number of doors, number of seats, and type of car. The surveillance-nature data contains 50,000 car images captured in the front view. Please refer to our paper for the details. \n The train/test subsets of these tasks introduced in our paper are included in the dataset. Researchers are also welcome to utilize it for any other tasks such as image ranking, multi-task learning, and 3D reconstruction. \n ## Input  \n A color (224x224) image of a car. \n ## Output \n The most likely type of car, for the given input. \n ## License \n MIT", image: #imageLiteral(resourceName: "Car Recognition Cover"), inputWidth: 224, inputHeight: 224, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/CarRecognition.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1YUIS8ATJ_Kt1VHJitDZuPzr_Wn6IPzs6")!, license: "MIT")
