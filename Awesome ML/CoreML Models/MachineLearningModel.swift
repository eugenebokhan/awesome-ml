//
//  MachineLearningModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 25/07/2018.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

public class MachineLearningModel: NSObject {
    
    // MARK: - Properties
    
    var name: String!
    var shortDescription: String!
    var detailedDescriptionURL: URL!
    var coverImage: UIImage!
    
    var machineLearningModelType: MachineLearningModelType!
}
