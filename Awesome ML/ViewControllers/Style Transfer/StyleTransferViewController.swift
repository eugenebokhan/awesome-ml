//
//  StyleTransferViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 4/4/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

@available(iOS, deprecated: 9.0)
class StyleTransferViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topVisualEffectViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomVisualEffectViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Interface Actions
    
    @IBAction func showImagePickerAction(_ sender: Any) {
        
        self.deselectAllItems(collectionView: self.collectionView)
        
        hideUIElements()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let camera = CameraViewController() { image in
                var animationDeadlineTime: Double
                if let image = image {
                    animationDeadlineTime = 0.8
                    self.originalImage = image
                    self.imageView.image = image
                } else {
                    animationDeadlineTime = 0.01
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDeadlineTime, execute: {
                    self.showUIElements()
                })
            }
            camera.modalTransitionStyle = .crossDissolve
            camera.modalPresentationStyle = .overFullScreen
            self.present(camera, animated: true, completion: nil)
        })
        
    }
    
    @IBAction func savePhotoAction(_ sender: Any) {
        showMoreAlert()
    }
    
    
    // MARK: - Other Properties
    
    var originalImage: UIImage!
    private var selectedIndex: Int?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = #imageLiteral(resourceName: "Default Image")
        originalImage = #imageLiteral(resourceName: "Default Image")
        configure(collectionView)
        setupBottomVisualEffectViewHeight()
        calculateBackgroundImageTranslationX()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for index in 0 ..< CoreMLStore.styleTransferModels.count {
            if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? StyleTransferCollectionViewCell {
                cell.configureDarkViewAppearance()
            }
        }
    }
    
    // MARK: - Setup Methods
    
    func setupBottomVisualEffectViewHeight() {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        bottomVisualEffectViewHeightConstraint.constant = screenHeight - topVisualEffectViewHeigthConstraint.constant - screenWidth
    }
    
    // MARK: - UI Methods
    
    func hideUIElements() {
        
        let topElemetsTranslationY: CGFloat = -100
        let bottomElemetsTranslationY: CGFloat = 200

            let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8, animations: {
                self.saveButton.transform = CGAffineTransform(translationX: 0, y: topElemetsTranslationY)
                self.cameraButton.transform = CGAffineTransform(translationX: 0, y: topElemetsTranslationY)
                
                self.collectionView.transform = CGAffineTransform(translationX: 0, y: bottomElemetsTranslationY)
                self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: bottomElemetsTranslationY)
            })
            animator.startAnimation()

    }
    
    func showUIElements() {

            let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8, animations: {
                self.saveButton.transform = .identity
                self.cameraButton.transform = .identity
                
                self.collectionView.transform = .identity
                self.tabBarController?.tabBar.transform = .identity
            })
            animator.startAnimation()

    }
    
    func showMoreAlert() {
        
        let alert = UIAlertController(title: "", message: "Save Image To Library", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.saveButton.setTitle("✓")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.saveButton.setTitle("Save")
            }
            
            guard let image = self.imageView.createImage() else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Collection View Delegate & Data Source

@available(iOS, deprecated: 9.0)
extension StyleTransferViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPrefetchingEnabled = true
    }
    
    func reloadCollectionView() {
        collectionView.performBatchUpdates({
            self.collectionView.reloadData()
        }) { (_) in
            self.calculateBackgroundImageTranslationX()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreMLStore.styleTransferModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StyleTransferModelCollectionViewCell", for: indexPath) as! StyleTransferCollectionViewCell
        
        let coreMLModel = CoreMLStore.styleTransferModels[indexPath.row]
        cell.coreMLModel = coreMLModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! StyleTransferCollectionViewCell
        
        deselectAllItems(collectionView: collectionView)
        
        // Scroll to selected item.
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if selectedIndex != indexPath.row {
            
            selectedIndex = indexPath.row
            
            if cell.isModelDownloaded() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    cell.runModel(originalImage: self.originalImage) { (stylizedImage) in
                        self.imageView.setImage(stylizedImage)
                        cell.isSelected = true
                    }
                }
            } else if indexPath.row == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.selectedIndex = nil
                    cell.isSelected = false
                    self.imageView.setImage(self.originalImage)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.selectedIndex = nil
                    cell.isSelected = false
                }
            }
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.selectedIndex = nil
                cell.isSelected = false
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! StyleTransferCollectionViewCell).configureDarkViewAppearance()
    }
    
    func deselectAllItems(collectionView: UICollectionView) {
        for index in 0 ..< CoreMLStore.styleTransferModels.count {
            if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) {
                cell.isSelected = false
            }
        }
    }
    
}

// MARK: ScrollView

@available(iOS, deprecated: 9.0)
extension StyleTransferViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        calculateBackgroundImageTranslationX()
        
    }
    
    func calculateBackgroundImageTranslationX() {
        DispatchQueue.main.async {
            for cell in self.collectionView.visibleCells as! [StyleTransferCollectionViewCell] {
                
                let indexPath = self.collectionView.indexPath(for: cell)!
                let attributes = self.collectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = self.collectionView.convert(attributes.frame, to: self.view)
                let translationX = cellFrame.origin.x / -15 + 10
                cell.backgroundImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
            }
        }
    }
}

