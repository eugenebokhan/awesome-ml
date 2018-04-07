//
//  PresentAssetClassViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class PresentDetailsViewController: NSObject, UIViewControllerAnimatedTransitioning {
    var cellFrame: CGRect!
    var hasWideScreen = false
    var backgroundImageTranslationY: CGFloat!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to) as! DetailsViewController
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        
        toVC.titleLabel.createShadow()
        toVC.captionLabel.createShadow()
        
        containerView.addSubview(toVC.view)
        
        toVC.scrollViewWidthConstraint.constant = cellFrame.width
        let translationX = cellFrame.origin.x - (bounds.width/2 - cellFrame.width/2)
        toVC.scrollView.transform = CGAffineTransform(translationX: translationX, y: 0)
        
        toVC.view.backgroundColor = .clear
        toVC.visualEffectView.frame = bounds
        toVC.view.insertSubview(toVC.visualEffectView, at: 0)
        UIView.animate(withDuration: 0.6, animations: {
            toVC.visualEffectView.effect = UIBlurEffect(style: .regular)
        })
        
        toVC.scrollViewTopConstraint.constant = cellFrame.origin.y - 20
        toVC.scrollViewLeadingConstraint.constant = cellFrame.origin.x
        toVC.scrollViewTrailingConstraint.constant = bounds.width - cellFrame.origin.x - cellFrame.width
        toVC.scrollViewBottomConstraint.constant = bounds.height - cellFrame.origin.y - cellFrame.height
        toVC.backgroundImageViewHeightConstraint.constant = cellFrame.height
        toVC.backgroundImageView.transform = CGAffineTransform(translationX: 0, y: self.backgroundImageTranslationY)
        toVC.scrollView.layer.cornerRadius = 14
        toVC.scrollView.layer.shadowOpacity = 0.25
        toVC.scrollView.layer.shadowOffset.height = 10
        toVC.scrollView.layer.shadowRadius = 20
        toVC.closeVisualEffectView.alpha = 0
        toVC.closeVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -100).concatenating(CGAffineTransform(scaleX: 2, y: 2))
        toVC.view.layoutIfNeeded()
        
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7) {
            if appHasBigScreenForView(toVC.view) {
                toVC.scrollViewWidthConstraint.constant = 728
                toVC.scrollView.transform = CGAffineTransform.identity
                toVC.scrollViewTopConstraint.constant = 0
                toVC.scrollViewBottomConstraint.constant = 0
                toVC.scrollView.layer.cornerRadius = 0
            } else {
                toVC.scrollViewTopConstraint.constant = 0
                toVC.scrollView.layer.cornerRadius = 0
            }
            
            toVC.titleLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 30, y: 10))
            toVC.scrollViewLeadingConstraint.constant = 0
            toVC.scrollViewTrailingConstraint.constant = 0
            toVC.scrollViewBottomConstraint.constant = 0
            toVC.backgroundImageViewHeightConstraint.constant = 420
            toVC.backgroundImageView.transform = .identity
            toVC.closeVisualEffectView.alpha = 1
            toVC.closeVisualEffectView.transform = CGAffineTransform.identity
            toVC.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
        animator.addCompletion { (finished) in
            if !appHasBigScreenForView(toVC.view) {
                toVC.scrollViewTopConstraint.constant = 0
                toVC.closeVisualEffectView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            
            transitionContext.completeTransition(true)
        }
    }
}
