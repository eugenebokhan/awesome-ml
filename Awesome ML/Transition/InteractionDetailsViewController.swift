//
//  InteractionAssetClassViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class InteractionDetailsViewController: UIPercentDrivenInteractiveTransition {
    weak var viewController: DetailsViewController!
    var shouldCompleteTransition = false
    var interactionInProgress = false {
        didSet {
            viewController.detailsTableView.isScrollEnabled = !interactionInProgress
        }
    }
    let visualEffectView = UIVisualEffectView()
    var isPanGestureEnabled = true
    private var transitionProgress: CGFloat = 0.0
    
    // MARK: Setup
    func wireToViewController(viewController: DetailsViewController) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController.view)
        visualEffectView.frame = viewController.view.frame
        viewController.view.insertSubview(visualEffectView, at: 0)
    }
    
    func prepareGestureRecognizerInView(view: UIView) {
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Gesture Events
    func began() {
        viewController.hideGetModelBackgroundView(animated: true)
    }
    
    override func update(_ percentComplete: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
        }
        
        // Same 15% progress to reach to final position
        let newRadius = min(20, 1 * (percentComplete * 134))
        let newScale = max(0.85, 1 - percentComplete)
        viewController.scrollView.transform = CGAffineTransform(scaleX: newScale, y: newScale)
        viewController.scrollView.layer.cornerRadius = newRadius
        viewController.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5) {
            self.viewController.closeVisualEffectView.alpha = 0
            self.viewController.closeVisualEffectView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        animator.startAnimation()
    }
    
    override func cancel() {
        viewController.showGetModelBackgroundView(animated: true)
        
        transitionProgress = 0.0
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6) {
            self.viewController.scrollView.transform = CGAffineTransform.identity
            self.viewController.scrollView.layer.cornerRadius = 0
            self.viewController.view.backgroundColor = UIColor(white: 0, alpha: 0)
            
            self.visualEffectView.effect = nil
            self.viewController.closeVisualEffectView.alpha = 1
            self.viewController.closeVisualEffectView.transform = CGAffineTransform.identity
        }
        animator.startAnimation()
    }
    
    override func finish() {
        transitionProgress = 0.0
        viewController.closeButtonTapped(self)
        self.visualEffectView.effect = nil
        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.viewController.view.backgroundColor = UIColor(white: 0, alpha: 0.0)
        }
    }
    
    // MARK: Handle Gesture
    @objc func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        let progress = translation.x / 200
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            began()
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            isPanGestureEnabled = false
        case .cancelled:
            interactionInProgress = false
            cancel()
            interactionInProgress = true
        case .ended:
            interactionInProgress = false
            if !shouldCompleteTransition {
                cancel()
                isPanGestureEnabled = true
            } else {
                finish()
            }
        default:
            print("Unsupported")
        }
    }
    
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard isPanGestureEnabled else { return }
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        
        gestureRecognizer.setTranslation(CGPoint.zero, in: gestureRecognizer.view?.superview)
        
        let scrollingDown = translation.y > 0
        let originalPosition = viewController.detailsTableView.contentOffset.y < 0.5 && viewController.viewTopConstraint.constant > -0.5
        
        if !interactionInProgress {
            guard scrollingDown && originalPosition else { return }
        }
        
        viewController.detailsTableView.contentOffset.y = 0.0
        viewController.viewTopConstraint.constant = 0.0
        
        transitionProgress += translation.y
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            began()
        case .changed:
            interactionInProgress = true
            let progress = transitionProgress/500
            shouldCompleteTransition = progress > 0.2
            update(progress)
            if transitionProgress <= 0 {
                interactionInProgress = false
            }
            if shouldCompleteTransition {
                interactionInProgress = false
                finish()
            }
        case .cancelled:
            interactionInProgress = false
            cancel()
            interactionInProgress = true
        case .ended:
            interactionInProgress = false
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
        default:
            print("Unsupported")
        }
    }
}

extension InteractionDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        isPanGestureEnabled = true
        return true
    }
}

