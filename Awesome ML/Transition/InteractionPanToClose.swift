//
//  InteractionPanToClose.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 25/07/2018.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class InteractionPanToClose: UIPercentDrivenInteractiveTransition {
    weak var viewController: UIViewController?
    weak var scrollView: UIScrollView?
    weak var dialogView: UIView?
    weak var backgroundView: UIVisualEffectView?
    var backgroundColorWhite: CGFloat = 0
    var backgroundViewEffect: UIVisualEffect!
    var isPanGestureEnabled = true
    var isDialogDropResetting = false
    var onDismiss: (()->())?
    
    func setPanGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        scrollView?.addGestureRecognizer(gesture)
        
        gesture.delegate = self
    }
    
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        guard isPanGestureEnabled else { return }
        if backgroundView?.effect != nil {
            self.backgroundViewEffect = backgroundView?.effect
        }
        guard (scrollView?.contentOffset.y ?? 0) < 1 else {
            if isPanGestureEnabled {
                cancel()
            }
            return
        }
        let translation = sender.translation(in: viewController?.view)
        let origin = sender.location(in: viewController?.view)
        
        switch sender.state {
        case .changed:
            guard translation.y > 0 else { return }
            update(translation, origin: origin)
        case .ended:
            if translation.y > 100 {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
    
    func update(_ translation: CGPoint, origin: CGPoint) {
        let multiplier = 1 - (translation.y / 10 / 200)
        
        let viewWidth = viewController?.view.frame.width ?? UIScreen.main.bounds.width
        let originX = 1 - (viewWidth - origin.x) / viewWidth
        let degrees = originX * 30 - 15
        let degreesWithMultiplier = (1 - multiplier) * 10 * degrees
        
        let translation = CGAffineTransform(translationX: 0, y: translation.y)
        let scale = CGAffineTransform(scaleX: multiplier, y: multiplier)
        let rotation = CGAffineTransform(rotationAngle: degreesToRadians(degrees: degreesWithMultiplier))
        dialogView?.transform = translation.concatenating(scale).concatenating(rotation)
        UIView.animate(withDuration: 0.5) {
            self.backgroundView?.effect = nil
        }
        viewController?.view.backgroundColor = UIColor(white: backgroundColorWhite, alpha: multiplier/1.5)
    }
    
    override func cancel() {
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6, animations: {
            self.dialogView?.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.5) {
                self.backgroundView?.effect = self.backgroundViewEffect
                self.viewController?.view.backgroundColor = UIColor(white: self.backgroundColorWhite, alpha: 0)
            }
        })
        animator.startAnimation()
    }
    
    override func finish() {
        let animator = UIViewPropertyAnimator(duration: 0.9, dampingRatio: 0.9, animations: {
            if self.isDialogDropResetting {
                self.dialogView?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 1000, 0)
            } else {
                self.dialogView?.frame.origin.y += 200
            }
            self.viewController?.dismiss(animated: true, completion: nil)
        })
        onDismiss?()
        animator.startAnimation()
    }
}

extension InteractionPanToClose: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        isPanGestureEnabled = true
        return true
    }
}

