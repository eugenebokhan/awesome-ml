//
//  StatusBar.swift
//  DesignCodeApp
//
//  Created by Meng To on 2017-08-08.
//  Copyright © 2017 Meng To. All rights reserved.
//

import UIKit

public func setStatusBarBackgroundColor(color: UIColor) {
    
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = color
}
