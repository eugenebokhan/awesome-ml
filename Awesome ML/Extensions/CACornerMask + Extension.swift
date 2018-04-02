//
//  CACornerMask + Extension.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

extension CACornerMask {
    
    var roundingCorner: UIRectCorner {
        if self == .layerMaxXMaxYCorner {
            return UIRectCorner.topRight
        }
        
        if self == .layerMaxXMinYCorner {
            return UIRectCorner.bottomRight
        }
        
        if self == .layerMinXMaxYCorner {
            return UIRectCorner.bottomLeft
        }
        
        return UIRectCorner.bottomLeft
    }
}
