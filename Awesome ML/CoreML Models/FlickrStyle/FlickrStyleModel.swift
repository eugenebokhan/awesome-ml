//
//  FlickrStyleModel.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/3/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public let flickrStyleModel = CoreMLModel(name: "FlickrStyle", coreMLType: .flickrStyle, author: "Finetuning CaffeNet on Flickr Style", modelDescription: "# Authors and Contributors \n Sergey Karayev, Matthew Trentacoste, Helen Han, Aseem Agarwala,  Trevor Darrell, Aaron Hertzmann, Holger Winnemoeller, University of California, Berkeley, Adobe. \n # Abstract \n The style of an image plays a significant role in how it is viewed, but style has re- ceived little attention in computer vision research. We describe an approach to predicting style of images, and perform a thorough evaluation of different image features for these tasks. We find that features learned in a multi-layer network generally perform best – even when trained with object class (not style) labels. Our large-scale learning methods results in the best published performance on an existing dataset of aesthetic ratings and photographic style annotations. We present two novel datasets: 80K Flickr photographs annotated with 20 curated style labels, and 85K paintings annotated with 25 style/genre labels. Our approach shows excellent classification performance on both datasets. We use the learned classifiers to extend traditional tag-based image search to consider stylis- tic constraints, and demonstrate cross-dataset understanding of style. \n ## Input  \n A color (227x227) image. \n ## Output \n The most likely style of image, for the given input. \n ## License \n Public Domain", image: #imageLiteral(resourceName: "Flicr Style Cover"), inputWidth: 227, inputHeight: 227, remoteURL: URL(string: "https://s3-us-west-2.amazonaws.com/coreml-models/FlickrStyle.mlmodel")!, remoteZipURL: URL(string: "https://drive.google.com/uc?export=download&id=1X6F3laayxFEiadTd-pvNR6odWeWKZ0-6")!, license: "MIT")
