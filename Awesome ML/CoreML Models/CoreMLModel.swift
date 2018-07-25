//
//  CoreMLModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

public class CoreMLModel: MachineLearningModel {
    
    // MARK: - Properties
    
    var inputWidth: Int!
    var inputHeight: Int!
    
    var remoteURL: URL?
    var remoteZipURL: URL?
    var localURL: URL? {
        didSet {
            print("Local URL: \(String(describing: localURL))")
        }
    }
    var localCompiledURL: URL!
    
    // MARK: - Lifecycle Methods
    
    init(name: String, machineLearningModelType: MachineLearningModelType, shortDescription: String, detailedDescriptionURL: URL, coverImage: UIImage?, inputWidth: Int, inputHeight: Int, remoteURL: URL?, remoteZipURL: URL?) {
        super.init()
        
        self.name = name
        self.machineLearningModelType = machineLearningModelType
        self.shortDescription = shortDescription
        self.detailedDescriptionURL = detailedDescriptionURL
        self.coverImage = coverImage ?? UIImage()
        self.inputWidth = inputWidth
        self.inputHeight = inputHeight
        
        if let remoteURL = remoteURL {
            self.remoteURL = remoteURL
            self.remoteZipURL = remoteZipURL
            
            let lastPathComponent = remoteURL.lastPathComponent
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
            self.localURL = URL(fileURLWithPath: documentsPath + "/" + lastPathComponent)
            self.localCompiledURL = URL(fileURLWithPath: documentsPath + "/" + lastPathComponent +  "c")
        }
        
    }
    
}

