//
//  ImageProcessingViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//


import UIKit

class ImageProcessingViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var statusBarVisualEfectView: UIVisualEffectView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Transition Properties
    
    let presentDetailsViewController = PresentDetailsViewController()
    let dismissDetailsViewController = DismissDetailsViewController()
    let interactionDetailsViewController = InteractionDetailsViewController()
    
    // MARK: - UI Properties
    
    private var hideStatusBar: Bool = false
    private var statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    // MARK: - Other Properties
    
    var selectedCellIndexPath: IndexPath?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(collectionView)
        setupNotifications()
        setupStatusBarBackgroundView()
        setupFurstLaunch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupFurstLaunch()
    }
    
    // MARK: - Setup UI
    
    func setupStatusBarBackgroundView() {
        statusBarHeightConstraint.constant = statusBarHeight
        blurStatusBar()
    }
    
    // MARK: - First Launch
    
    func setupFurstLaunch() {
        
        let isFirstLaunch: Bool = UserDefaults.standard.object(forKey: "isFirstLaunch") == nil
        
        if isFirstLaunch {
            UserDefaults.standard.set("No", forKey:"isFirstLaunch")
            UserDefaults.standard.synchronize()
            
            self.collectionView.alpha = 0
            self.tabBarController?.tabBar.alpha = 0
            self.statusBarVisualEfectView.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.presentFirstLaunchViewController(completion: {
                    UIView.animate(withDuration: 0.6, animations: {
                        
                        self.collectionView.alpha = 1
                        self.tabBarController?.tabBar.alpha = 1
                        self.statusBarVisualEfectView.alpha = 1
                        
                    })
                })
            }
        }
        
    }
    
    func presentFirstLaunchViewController(completion: @escaping () -> Void) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let firstLaunchViewController = FirstLaunchViewController(collectionViewLayout: layout)
        firstLaunchViewController.modalTransitionStyle = .crossDissolve
        
        self.present(firstLaunchViewController, animated: true) {
            completion()
        }
    }
    
    // MARK: - Notifications
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    @objc func handleNotification(_ notification: NSNotification) {
        if notification.name == UIApplication.didChangeStatusBarOrientationNotification {
            
            reloadCollectionView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let selectedCellIndexPath = self.selectedCellIndexPath {
                    
                    if let selectedCell = self.collectionView.cellForItem(at: selectedCellIndexPath) as? CoreMLModelCollectionViewCell {
                        
                        self.presentDetailsViewController.cellFrame = selectedCell.frame
                        self.dismissDetailsViewController.cellFrame = selectedCell.frame
                        self.dismissDetailsViewController.coreMLCell = selectedCell
                        
                        let userInfo = ["selectedCell" : selectedCell]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Location Collection View Cell Crame Update"), object: self, userInfo: userInfo)
                    }
                }
            }
            
        }
    }
    
}

// MARK: - Collection View Delegate & Data Source

extension ImageProcessingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPrefetchingEnabled = true
    }
    
    func reloadCollectionView() {
        collectionView.performBatchUpdates({
            self.collectionView.reloadData()
        }) { (_) in
            self.calculateBackgroundImageTranslationY()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreMLStore.imageProcessingModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoreMLModelCollectionViewCell", for: indexPath) as! CoreMLModelCollectionViewCell
        
        let coreMLModel = CoreMLStore.imageProcessingModels[indexPath.row]
        cell.coreMLModel = coreMLModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.2,
                           options: .beginFromCurrentState,
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.2,
                           options: .beginFromCurrentState,
                           animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get cell frame for transition
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
        let cellFrame = collectionView.convert(attributes.frame, to: view)
        presentDetailsViewController.cellFrame = cellFrame
        dismissDetailsViewController.cellFrame = cellFrame
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CoreMLModelCollectionViewCell else { return }
        
        presentDetailsViewController.backgroundImageTranslationY = cell.backgroundImageTranslationY
        dismissDetailsViewController.backgroundImageTranslationY = cell.backgroundImageTranslationY
        
        dismissDetailsViewController.coreMLCell = cell
        
        selectedCellIndexPath = indexPath
        
        hideStatusBarAnimated()
        hideTabBarAnimated()
        unblurStatusBar()
        
        performSegue(withIdentifier: "CoreMLModelCollectionViewCellToDetail", sender: cell)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CoreMLModelCollectionViewCellToDetail" {
            
            let toView = segue.destination as! DetailsViewController
            
            let cell = sender as! CoreMLModelCollectionViewCell
            toView.cell = cell
            
            toView.transitioningDelegate = self
            toView.delegate = self
            
            toView.hidesBottomBarWhenPushed = true
            
            //            interactionAssetClassViewController.wireToViewController(viewController: toView)
            
        }
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageProcessingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            let cellHeight = collectionView.bounds.height / 1.6
            
            return CGSize(width: collectionView.bounds.width, height: cellHeight)
            
        } else {
            
            // Number of Items per Row
            let numberOfItemsInRow = 2
            
            if UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown {
                
                let width = collectionView.bounds.width / 2.36
                let height = collectionView.bounds.height / 2.6
                
                return CGSize(width: width, height: height)
                
            } else {
                
                let cellHeight = collectionView.bounds.height / 2.2
                
                // Current Row Number
                let rowNumber = indexPath.item/numberOfItemsInRow
                
                // Compressed With
                let compressedWidth = collectionView.bounds.width / 3.4
                
                // Expanded Width
                let expandedWidth = (collectionView.bounds.width / 3.4) * 2
                
                // Is Even Row
                let isEvenRow = rowNumber % 2 == 0
                
                // Is First Item in Row
                let isFirstItem = indexPath.item % numberOfItemsInRow != 0
                
                // Calculate Width
                var width: CGFloat = 0.0
                if isEvenRow {
                    width = isFirstItem ? compressedWidth : expandedWidth
                } else {
                    width = isFirstItem ? expandedWidth : compressedWidth
                }
                
                return CGSize(width: width, height: cellHeight)
                
            }
        }
    }
    
}

// MARK: - Transition

extension ImageProcessingViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentDetailsViewController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissDetailsViewController
    }
    
    //    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //        return interactionAssetClassViewController.interactionInProgress ? interactionAssetClassViewController : nil
    //    }
    
}

// MARK: - Status Bar

extension ImageProcessingViewController: DetailsViewControllerDelegate {
    
    func detailsViewControllerDismiss(cell: CoreMLModelCollectionViewCell) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showStatusBarAnimated()
            self.showTabBarAnimated()
            self.blurStatusBar()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
    
    func hideStatusBarAnimated() {
        hideStatusBar = true
        view.frame.origin.y += statusBarHeight
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func showStatusBarAnimated() {
        hideStatusBar = false
        view.frame.origin.y -= statusBarHeight
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func blurStatusBar() {
        self.statusBarVisualEfectView.fadeInEffect()
    }
    
    func unblurStatusBar() {
        self.statusBarVisualEfectView.fadeOutEffect()
    }
    
    // MARK: - Status Bar
    
    func hideTabBarAnimated() {
        if var frame = self.tabBarController?.tabBar.frame {
            frame.origin.y += frame.size.height
            let animator = UIViewPropertyAnimator(duration: 0.35, curve: .easeIn) {
                self.tabBarController?.tabBar.frame = frame
            }
            animator.startAnimation(afterDelay: 0)
        }
    }
    
    func showTabBarAnimated() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    if var frame = self.tabBarController?.tabBar.frame {
                        frame.origin.y -= frame.size.height
                        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut) {
                            self.tabBarController?.tabBar.frame = frame
                        }
                        animator.startAnimation(afterDelay: 0.7)
                    }
                })
            default:
                if var frame = self.tabBarController?.tabBar.frame {
                    frame.origin.y += frame.size.height
                    self.tabBarController?.tabBar.frame = frame
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    if var frame = self.tabBarController?.tabBar.frame {
                        frame.origin.y -= frame.size.height
                        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut) {
                            self.tabBarController?.tabBar.frame = frame
                        }
                        animator.startAnimation(afterDelay: 0.7)
                    }
                })
            }
        }
        
    }
    
}

// MARK: ScrollView

extension ImageProcessingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        calculateBackgroundImageTranslationY()
        
    }
    
    func calculateBackgroundImageTranslationY() {
        DispatchQueue.main.async {
            for cell in self.collectionView.visibleCells as! [CoreMLModelCollectionViewCell] {
                
                let indexPath = self.collectionView.indexPath(for: cell)!
                let attributes = self.collectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = self.collectionView.convert(attributes.frame, to: self.view)
                let translationY = cellFrame.origin.y / -15
                cell.backgroundImageTranslationY = translationY
                cell.backgroundImageView.transform = CGAffineTransform(translationX: 0, y: translationY)
            }
        }
    }
}


