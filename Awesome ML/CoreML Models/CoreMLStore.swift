//
//  CoreMLStore.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

public enum CoreMLType: String {
    case mobileOpenPose = "MobileOpenPose"
    case tinyYOLO = "Tiny YOLO"
    case ageNet = "AgeNet"
    case carRecognition = "CarRecognition"
    case cnnEmotions = "CNNEmotions"
    case flickrStyle = "FlickrStyle"
    case food101 = "Food101"
    case genderNet = "GenderNet"
    case googleNetPlaces = "Google Net Places"
    case inceptionv3 = "Inceptionv3"
    case mnist = "MNIST"
    case mobileNet = "MobileNet"
    case nudity = "Nudity"
    case oxford102 = "Oxford102"
    case resnet50 = "Resnet50"
    case rn1015k500 = "RN1015k500"
    case vgg16 = "VGG16"
    case visualSentimentCNN = "VisualSentimentCNN"
    
    case fnsCandy = "FNS-Candy"
    case fnsTheScream = "FNS-TheScream"
    case fnsUndie = "FNS-Undie"
    case fnsLaMuse = "FNS-LaMuse"
    case fnsMosaic = "FNS-Mosaic"
    case fnsFeathers = "FNS-Feathers"
    case fnsRainPrincess = "FNS-RainPrincess"
    case fnsWave = "FNS-Wave"
    case normal = "Normal"
}

class CoreMLStore: NSObject {
    
    static let imageProcessingModels: [CoreMLModel] = [mobileOpenPoseModel, carRecognitionModel, tinyYOLOModel, visualSentimentCNNModel, googLeNetPlacesModel,oxford102Model, food101Model, resnet50Model, flickrStyleModel, mobileNetModel, nudityModel, inceptionv3Model, mnistModel, ageNetModel]
    
    
    
    static let styleTransferModels: [CoreMLModel] = [normalModel, fnsWaveModel, fnsRainPrincessModel, fnsCandyModel, fnsFeathersModel, fnsUndieModel, fnsLaMuseModel, fnsMosaicModel, fnsTheScreamModel]
    
    static func isModelDownloaded(coreMLModel: CoreMLModel?) -> Bool {
        guard let coreMLModel = coreMLModel else { return false }
        guard let localCompiledURL = coreMLModel.localCompiledURL else { return false }
        return FileManager.default.fileExists(atPath: localCompiledURL.path)
    }

}

let normalModel = CoreMLModel(name: "Normal", coreMLType: .normal, shortDescription: "No Filter", detailedDescription: "", image: #imageLiteral(resourceName: "Normal Style"), inputWidth: 720, inputHeight: 720, remoteURL: nil, remoteZipURL: nil, license: "")
