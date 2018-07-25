//
//  UIImageView + Extensions.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func createShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.masksToBounds = false
    }
    
    func setImage(_ newImage: UIImage) {
        UIView.transition(with: self,
                          duration:0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.image = newImage },
                          completion: nil)
    }
    
}
