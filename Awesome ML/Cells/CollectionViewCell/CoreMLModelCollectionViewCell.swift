//
//  DetailCollectionViewCell.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit
import MapKit

class CoreMLModelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Properties
    
    var coreMLModel: CoreMLModel! {
        didSet {
            DispatchQueue.main.async {
                self.setupLabels()
                self.setupBackgrounImage()
            }
        }
    }
    var backgroundImageTranslationY: CGFloat!
    
    // Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    // Setup Methods
    
    func setupLabels() {
        
        title.text = coreMLModel.name
        subtitle.text = coreMLModel.shortDescription
        
        title.createShadow()
        subtitle.createShadow()
    }
    
    func setupBackgrounImage() {
        self.backgroundImageView.image = coreMLModel.image
    }
    
}



