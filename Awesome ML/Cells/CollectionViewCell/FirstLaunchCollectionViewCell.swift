//
//  FirstLaunchCollectionViewCell.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class FirstLaunchCollectionViewCell: UICollectionViewCell {
    
    var firstLaunchPageInfo : FirstLaunchPage? {
        didSet {
            if let iconImage = firstLaunchPageInfo?.image {
                iconImageView.image = UIImage(named: iconImage)
            }
            
            if let titleString = firstLaunchPageInfo?.title, let descString = firstLaunchPageInfo?.description {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .center
                let bodyText = NSMutableAttributedString(string: titleString.uppercased(), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                                                                                                        NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3372146487, green: 0.3372780979, blue: 0.337210536, alpha: 1),
                                                                                                        NSAttributedString.Key.paragraphStyle : paragraph
                    ])
                bodyText.append(NSAttributedString(string: "\n\n" + descString, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular),
                                                                                             NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3372146487, green: 0.3372780979, blue: 0.337210536, alpha: 1),
                                                                                             NSAttributedString.Key.paragraphStyle : paragraph
                    ]))
                bodyTextView.attributedText = bodyText
            }
            
        }
    }
    
    let iconContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let bodyTextView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        
        // Set View Background Color
        backgroundColor = #colorLiteral(red: 0.920707047, green: 0.9256237149, blue: 0.9297667146, alpha: 1)
        
        // Setup Contraints and Views
        addSubview(iconContainer)
        iconContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        iconContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        iconContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        iconContainer.addSubview(iconImageView)
        iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconContainer.widthAnchor, multiplier: 0.5).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconContainer.heightAnchor, multiplier: 0.5).isActive = true
        addSubview(bodyTextView)
        bodyTextView.topAnchor.constraint(equalTo: iconContainer.bottomAnchor).isActive = true
        bodyTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        bodyTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        bodyTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}


