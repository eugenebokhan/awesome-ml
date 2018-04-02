//
//  UIView + Exatension.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

extension UIView {
    
    func set(maskedCorners: CACornerMask) {
        if #available(iOS 11.0, *) {
            layer.maskedCorners = maskedCorners
        } else {
            
            let maskPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: maskedCorners.roundingCorner,
                                        cornerRadii: CGSize(width: 18.0, height: 0.0))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
    }
    
    func createImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
        
    }
    
}
