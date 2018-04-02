//
//  SpringTransform.swift
//  DesignCodeApp
//
//  Created by Meng To on 2017-08-10.
//  Copyright © 2017 Meng To. All rights reserved.
//

import UIKit

public func spring3DRotate(degrees: Double) -> CATransform3D {
    var transform = CATransform3DIdentity
    transform.m34 = -1.0/1000
    let angle = CGFloat((degrees * Double.pi) / 180.0)
    let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
    return rotation
}

public func spring3DTranslate(x: CGFloat, y : CGFloat, z: CGFloat) -> CATransform3D {
    var transform = CATransform3DIdentity
    transform.m34 = -1.0/2500
    let translation = CATransform3DTranslate(transform, x, y, z)
    return translation
}

open class SpringAnimator: NSObject {
    var duration: TimeInterval
    var animation: String
    var dampingRatio: CGFloat
    
    init(duration: TimeInterval, animation: String, dampingRatio: CGFloat) {
        self.duration = 1
        self.animation = "Flip"
        self.dampingRatio = 0.8
    }
    
    func animate(animations: @escaping () -> Void) {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio) {
            animations()
        }
        animator.startAnimation()
    }
}
