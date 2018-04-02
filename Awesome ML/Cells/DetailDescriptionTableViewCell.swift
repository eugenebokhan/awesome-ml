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
    
    @IBOutlet weak var descriptionMarkdownView: MarkdownView!
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionBackgroundView: UIView!
    
    // Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        descriptionBackgroundView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.4) {
                self.descriptionBackgroundView.alpha = 1
            }
        }
    }
    
    
}
