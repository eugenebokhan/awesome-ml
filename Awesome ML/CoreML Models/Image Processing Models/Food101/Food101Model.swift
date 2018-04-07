//
//  Food101Model.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let food101Model = CoreMLModel(name: "Food101", coreMLType: .food101, shortDescription: "This model takes a picture of a food and predicts its name", detailedDescription: "# Authors and Contributors \n Sergey Karayev, Matthew Trentacoste, Helen Han, Aseem Agarwala,  Trevor Darrell, Aaron Hertzmann, Holger Winnemoeller, University of California, Berkeley, Adobe. \n # Description \n UPMC Food-101 is a large multimodal dataset containing about 100,000 items of food recipes classified in 101 categories. This dataset was crawled from the web and each item consists of an image and the HTML webpage on which it was found. This dataset can be considered as a “twin dataset” of ETHZ Food-101. Indeed, they both share the same 101 categories and have approximately the same size. The categories of both UPMC Food-101 and ETHZ Food-101 are the 101 most popular categories from the food picture sharing website foodspotting.com. However, the images from ETHZ Food-101 are also taken from this website whereas UPMC Food-101's images have been crawled from Google Images searches of the category name followed by “recipe”. \n ## Input  \n A color (299x299) image. \n ## Output \n Label of predicted food. \n ## License \n Public Domain.", image: #imageLiteral(resourceName: "Food101 Cover"), inputWidth: 299, inputHeight: 299, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/Food101.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1DYpcEYTxKO7KJiWRwDe4KVIGvUxyVHpe")!, license: "MIT")

