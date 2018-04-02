//
//  CoreMLModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class CoreMLModel: NSObject {
    
    // MARK: - Properties
    
    var name: String!
    var author: String!
    var modelDescription: String!
    var license: String!
    var image: UIImage!
    
    var inputWidth: Int!
    var inputHeight: Int!
    
    var coreMLType: CoreMLType!
    
    var remoteURL: URL!
    var remoteZipURL: URL!
    var localURL: URL! {
        didSet {
            print("Local URL: \(localURL)")
        }
    }
    var localCompiledURL: URL!
    
    // MARK: - Lifecycle Methods
    
    init(name: String, coreMLType: CoreMLType, author: String, modelDescription: String, image: UIImage?, inputWidth: Int, inputHeight: Int, remoteURL: URL, remoteZipURL: URL, license: String) {
        super.init()
        
        self.name = name
        self.coreMLType = coreMLType
        self.author = author
        self.modelDescription = modelDescription
        self.license = license
        self.image = image ?? UIImage()
        self.inputWidth = inputWidth
        self.inputHeight = inputHeight
        
        self.remoteURL = remoteURL
        self.remoteZipURL = remoteZipURL
        
        let lastPathComponent = remoteURL.lastPathComponent
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        self.localURL = URL(fileURLWithPath: documentsPath + "/" + lastPathComponent)
        self.localCompiledURL = URL(fileURLWithPath: documentsPath + "/" + lastPathComponent +  "c")

    }

}
