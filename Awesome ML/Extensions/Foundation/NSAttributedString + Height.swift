//
//  NSAttributedString + Height.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 25/07/2018.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

extension NSAttributedString {
    func heightWithWidth(width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics], context: nil)
        
        return boundingBox.height
    }
}
