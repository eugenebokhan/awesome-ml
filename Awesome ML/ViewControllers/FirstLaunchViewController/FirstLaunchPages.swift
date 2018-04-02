//
//  FirstLaunchPages.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

struct FirstLaunchPage {
    
    let title : String
    let description : String
    let image : String
    
}

let firstLaunchPages = [FirstLaunchPage(title: "Take advantage of Core ML", description: "Core ML lets you integrate a broad variety of machine learning model types into your app.", image: "slide1"),
                       FirstLaunchPage(title: "Test Core ML models", description: "This app lets you test Core ML models and it’s applications.", image: "slide2"),
                       FirstLaunchPage(title: "Allow access to your camera", description: "We need access to your iPhone's camera in order to let you test some of the Core ML models.", image: "slide4")
]

