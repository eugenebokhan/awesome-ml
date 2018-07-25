//
//  DetailDescriptionTableViewCell.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class DetailDescriptionTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
    }
    
    
}
