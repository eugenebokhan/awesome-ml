// The MIT License (MIT)
//
// Copyright (c) 2015 Meng To (meng@designcode.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

@IBDesignable class DesignableTabBarController: UITabBarController {
    
    @IBInspectable var firstImage: UIImage? {
        didSet {
            if let image = firstImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[0].image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var firstSelectedImage: UIImage? {
        didSet {
            if let image = firstSelectedImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[0].selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var secondImage: UIImage? {
        didSet {
            if let image = firstImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[1].image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var secondSelectedImage: UIImage? {
        didSet {
            if let image = firstSelectedImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[1].selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var thirdImage: UIImage? {
        didSet {
            if let image = firstImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[2].image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var thirdSelectedImage: UIImage? {
        didSet {
            if let image = thirdSelectedImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[2].selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var fourthImage: UIImage? {
        didSet {
            if let image = firstImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[3].image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var fourthSelectedImage: UIImage? {
        didSet {
            if let image = firstSelectedImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[3].selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var fifthImage: UIImage? {
        didSet {
            if let image = firstImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[4].image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
    
    @IBInspectable var fifthSelectedImage: UIImage? {
        didSet {
            if let image = firstSelectedImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[4].selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
}

