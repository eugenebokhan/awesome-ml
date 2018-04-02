//
//  FirstLaunchViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit
import AVKit

class FirstLaunchViewController: UICollectionViewController {
    
    // MARK: - UI Elements
    
    let pageControl : UIPageControl = {
        
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = firstLaunchPages.count
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
        
    }()
    
    let startButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.920707047, green: 0.9256237149, blue: 0.9297667146, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3372146487, green: 0.3372780979, blue: 0.337210536, alpha: 1)
        button.layer.cornerRadius = 10
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
        
    }()
    
    // MARK: - UI Actions
    
    @objc func startTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(FirstLaunchCollectionViewCell.self, forCellWithReuseIdentifier: "pageId")
        collectionView?.isPagingEnabled = true
        
        setupView()
        
    }
    
    // MARK: - Setups
    
    private func setupView(){
        
        view.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(startButton)
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -10).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func askForCameraPermission() {
        
        let mediaType = AVMediaType.video
        AVCaptureDevice.requestAccess(for: mediaType) {
            (granted) in
            if granted == false {
                let alert = UIAlertController(title: "Sorry, we need access!", message: "We need access to your iPhone's camera in order to let you test some of the Core ML models.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Set Permission", style: .default, handler: { (_) in
                    self.askForCameraPermission()
                }))
            }
        }
        
    }
    
}

// Collection View Delegate

extension FirstLaunchViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firstLaunchPages.count
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            showStartButton()
            askForCameraPermission()
        } else {
            hideStartButton()
        }
        
    }
    
    func hideStartButton() {
        UIView.animate(withDuration: 0.3) {
            self.startButton.alpha = 0
        }
    }
    
    func showStartButton() {
        UIView.animate(withDuration: 0.3) {
            self.startButton.alpha = 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageId", for: indexPath) as! FirstLaunchCollectionViewCell
        cell.firstLaunchPageInfo = firstLaunchPages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
}

