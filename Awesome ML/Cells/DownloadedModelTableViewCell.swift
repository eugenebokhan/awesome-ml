//
//  DownloadedModelTableViewCell.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class DownloadedModelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var modelNameLabel: UILabel!
    
    @IBOutlet weak var modelSizeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
