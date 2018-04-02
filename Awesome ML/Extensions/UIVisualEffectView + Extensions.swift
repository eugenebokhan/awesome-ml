//
//  UIVisualEffectView + Extensions.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class VisualEffectView: UIVisualEffectView {
    
    public enum PresentationType {
        case right
        case left
        case up
        case down
        case custom(degrees: CGFloat, radius: CGFloat)
    }
    
    /**
     CGoint sets the initial and translated positions. Used for show and hide methods.
     
     By default the value is set to (0, 0)
     */
    public var initialPosition = CGPoint()
    public var translatedPosition = CGPoint()
    
    public var presentationType: PresentationType? {
        didSet { setupPositions() }
    }
    
    private func setupPositions() {
        
        switch self.presentationType {
        case .down?:
            self.initialPosition = CGPoint(x: self.bounds.origin.x, y: -self.bounds.size.height)
            self.translatedPosition = self.bounds.origin
        case .up?:
            self.initialPosition = CGPoint(x: self.bounds.origin.x, y: (self.superview?.bounds.size.height)!)
            self.translatedPosition = self.bounds.origin
        case .left?:
            self.initialPosition = CGPoint(x: -self.bounds.size.width, y: self.bounds.origin.y)
            self.translatedPosition = self.bounds.origin
        case .right?:
            self.initialPosition = CGPoint(x: (self.superview?.bounds.size.width)!, y: self.bounds.origin.y)
            self.translatedPosition = self.bounds.origin
        case .custom(let degrees, let radius)?:
            let x = self.bounds.width * radius * sin(degreesToRadians(degrees: degrees))
            let y = self.bounds.width * radius * cos(degreesToRadians(degrees: degrees))
            self.initialPosition = self.bounds.origin
            self.translatedPosition = CGPoint(x: x, y: y)
        case .none:
            break
        }
    }
    
    // Show & hide methods
    
    func show() {
        
        // Enable button and make it visible
        switch self.presentationType {
        case .some(.right):
            self.isHidden = false
        case .some(.left):
            self.isHidden = false
        case .some(.up):
            self.isHidden = false
        case .some(.down):
            self.isHidden = false
        case .custom( _, _)?:
            self.isHidden = false
        case .none:
            self.isHidden = false
        }
    }
    
    func hide() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Disable button and make it invisible
            self.isHidden = true
        }
        
    }
    
    func shake() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        self.contentView.layer.add(animation, forKey: "position")
        
    }
    
}

//extension UIVisualEffectView {
//
//    /**
//     CGoint sets the initial and translated positions. Used for show and hide methods.
//
//     By default the value is set to (0, 0)
//     */
//    public var initialPosition = CGPoint()
//    public var translatedPosition = CGPoint()
//
//    public var presentationType: PresentationType? {
//        didSet { setupPositions() }
//    }
//
//    // Show & hide methods
//
//    func show() {
//
//        // Present button with animation
//        let translationAnimation = animationWithKeyPath("transform.translation", damping: 20, stiffness: 125, duration: 0.8)
//        translationAnimation.isRemovedOnCompletion = false
//        translationAnimation.fromValue = self.initialPosition
//        translationAnimation.toValue = self.translatedPosition
//        self.layer.add(translationAnimation, forKey: "translation")
//
//        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
//        opacityAnimation.isRemovedOnCompletion = false
//        opacityAnimation.fromValue = 0.7
//        opacityAnimation.toValue = 1
//        self.layer.add(opacityAnimation, forKey: "opacity")
//
//        // Enable button and make it visible
//        switch self.presentationType {
//        case .some(.right):
//            self.isEnabled = true
//            self.isHidden = false
//        case .some(.left):
//            self.isEnabled = true
//            self.isHidden = false
//        case .some(.up):
//            self.isEnabled = true
//            self.isHidden = false
//        case .some(.down):
//            self.isEnabled = true
//            self.isHidden = false
//        case .custom( _, _)?:
//            self.isHidden = false
//        case .none:
//            self.isEnabled = true
//            self.isHidden = false
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
//            switch self.presentationType {
//            case .some(.right):
//                self.layer.setAffineTransform(CGAffineTransform.identity)
//            case .some(.left):
//                self.layer.setAffineTransform(CGAffineTransform.identity)
//            case .some(.up):
//                self.layer.setAffineTransform(CGAffineTransform.identity)
//            case .some(.down):
//                self.layer.setAffineTransform(CGAffineTransform.identity)
//            case .custom(let degrees, let radius)?:
//                let x = self.bounds.width * radius * sin(degreesToRadians(degrees: degrees))
//                let y = self.bounds.width * radius * cos(degreesToRadians(degrees: degrees))
//                self.layer.setAffineTransform(CGAffineTransform(translationX: x, y: y))
//            case .none:
//                break
//            }
//        }
//    }
//
//    func hide() {
//
//        let translationAnimation = animationWithKeyPath("transform.translation", damping: 20, stiffness: 10, duration: 0.8)
//        translationAnimation.isRemovedOnCompletion = false
//        translationAnimation.fromValue = self.translatedPosition
//        translationAnimation.toValue = self.initialPosition
//        self.layer.add(translationAnimation, forKey: "translation")
//
//        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
//        opacityAnimation.isRemovedOnCompletion = false
//        opacityAnimation.fromValue = 1
//        opacityAnimation.toValue = 0.7
//        self.layer.add(opacityAnimation, forKey: "opacity")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            // Disable button and make it invisible
//            self.isEnabled = false
//            self.isHidden = true
//            self.isSelected = false
//
//            self.layer.setAffineTransform(CGAffineTransform.identity)
//        }
//
//    }
//
//    func shake() {
//
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 0.07
//        animation.repeatCount = 4
//        animation.autoreverses = true
//        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
//        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
//        self.layer.add(animation, forKey: "position")
//
//    }
//
//}

public extension UIVisualEffectView {
    
    public func fadeInEffect(_ style:UIBlurEffectStyle = .regular, withDuration duration: TimeInterval = 6.0) {
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
                self.effect = UIBlurEffect(style: style)
            }
            
            animator.startAnimation()
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: duration) {
                self.effect = UIBlurEffect(style: style)
            }
        }
    }
    
    public func fadeOutEffect(withDuration duration: TimeInterval = 6.0) {
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                self.effect = nil
            }
            
            animator.startAnimation()
            animator.fractionComplete = 1
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: duration) {
                self.effect = nil
            }
        }
    }
    
}
