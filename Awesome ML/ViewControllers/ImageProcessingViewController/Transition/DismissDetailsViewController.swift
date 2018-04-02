//
//  DismissAssetClassViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class DismissDetailsViewController: NSObject, UIViewControllerAnimatedTransitioning {
    var cellFrame: CGRect!
    var coreMLCell: CoreMLModelCollectionViewCell!
    var hasWideScreen = false
    var backgroundImageTranslationY: CGFloat!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .from) as! DetailsViewController
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        
        toVC.backgroundImageView.transform = .identity
        
        toVC.titleLabel.createShadow()
        toVC.captionLabel.createShadow()
        
        containerView.addSubview(toVC.view)
        
        toVC.scrollViewTopConstraint.constant = 30
        UIView.animate(withDuration: 0.6, animations: {
            toVC.visualEffectView.effect = nil
            toVC.titleLabel.textColor = .white
            toVC.captionLabel.textColor = UIColor(white: 1, alpha: 0.8)
        })
        
        // Animator setup
        if appHasWideScreenForView(toVC.view) {
            
            toVC.scrollViewWidthConstraint.constant = self.cellFrame.width
            
            let translationX = self.cellFrame.origin.x - (bounds.width/2 - self.cellFrame.width/2)
            toVC.scrollViewCenterXConstraint.constant = translationX
            toVC.viewTopConstraint.constant = 20
            
            toVC.scrollView.set(maskedCorners: [
                .layerMaxXMinYCorner,
                .layerMinXMinYCorner,
                .layerMaxXMaxYCorner,
                .layerMinXMaxYCorner])
            
            toVC.scrollViewTopConstraint.constant = self.cellFrame.origin.y
        } else {
            toVC.scrollViewTopConstraint.constant = self.cellFrame.origin.y
        }
        
        toVC.viewTopConstraint.constant = 0
        
        toVC.scrollViewLeadingConstraint.constant = self.cellFrame.origin.x
        toVC.scrollViewTrailingConstraint.constant = bounds.width - self.cellFrame.origin.x - self.cellFrame.width
        toVC.scrollViewBottomConstraint.constant = bounds.height - self.cellFrame.origin.y - self.cellFrame.height
        toVC.backgroundImageViewHeightConstraint.constant = self.cellFrame.height
        
        toVC.view.setNeedsLayout()
        
        let animator = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.9) {
            if appHasWideScreenForView(toVC.view) {
                
                toVC.scrollView.layer.transform = CATransform3DIdentity
                
                if self.coreMLCell.backgroundImageView.transform != .identity {
                    let imageTranslationX = self.cellFrame.origin.x / 17
                    toVC.backgroundImageView.transform = CGAffineTransform(translationX: imageTranslationX, y: self.backgroundImageTranslationY)
                }
            } else {
                
                toVC.scrollView.layer.transform = CATransform3DIdentity
                
                if self.coreMLCell.backgroundImageView.transform != .identity {
                    let translationX = self.cellFrame.origin.x / 5
                    toVC.backgroundImageView.transform = CGAffineTransform(translationX: translationX, y: self.backgroundImageTranslationY)
                }
            }
            
            toVC.backgroundImageView.transform = CGAffineTransform(translationX: 0, y: self.backgroundImageTranslationY)
            
            toVC.scrollView.layer.cornerRadius = 14
            toVC.closeVisualEffectView.alpha = 0
            toVC.closeVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -100)
            
            // iPhone X
            toVC.titleLabel.transform = CGAffineTransform(translationX: 0, y: -26)
            toVC.captionLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            
            toVC.detailsTableView.tableHeaderView?.bounds.size.height = self.cellFrame.size.height
            
            toVC.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
        
        animator.addCompletion { (finished) in
            toVC.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
