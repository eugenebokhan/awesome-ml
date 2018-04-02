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

public extension String {
    public var length: Int { return self.characters.count }
    
    public func toURL() -> NSURL? {
        return NSURL(string: self)
    }
}

public func htmlToAttributedString(text: String) -> NSAttributedString! {
    guard let htmlData = text.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
        return NSAttributedString() }
    let htmlString: NSAttributedString?
    do {
        htmlString = try NSAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil)
    } catch _ {
        htmlString = nil
    }
    
    return htmlString
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

private let characterEntities : [ String : Character ] = [
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    "&nbsp;"    : "\u{00a0}",
    "&diams;"   : "♦",
]

extension String {
    var stringByDecodingHTMLEntities : String {
        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(String(entity[entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)]), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(String(entity[entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)]), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        var result = ""
        var position = startIndex
        
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(String(self[position ..< ampRange.lowerBound]))
            position = ampRange.lowerBound
            
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = String(self[position ..< semiRange.upperBound])
                position = semiRange.upperBound
                
                if let decoded = decode(String(entity)) {
                    result.append(decoded)
                } else {
                    result.append(entity)
                }
            } else {
                break
            }
        }
        result.append(String(self[position ..< endIndex]))
        return result
    }
}

extension String {
    var utf8ToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var utf8ToString: String {
        return utf8ToAttributedString?.string ?? ""
    }
}

extension String{
    var htmlRemoveTags: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var hasHTML: Bool {
        return hasSuffix(">")
    }
    
    var hasUnparsableHTML: Bool {
        return contains("<a") || contains("<b")
    }
    
    var hasHTMLOtherThanParagraph: Bool {
        return (contains("<a") || contains("<b") || contains("<strong") ||  contains("<p></p>")) || contains("<c") || contains("<ul")
    }
    
    var hasHTMLLink: Bool {
        return contains("<a")
    }
}

public func degreesToRadians(degrees: CGFloat) -> CGFloat {
    return degrees * CGFloat(CGFloat.pi / 180)
}

public func delay(delay:Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

public func imageFromURL(_ Url: String) -> UIImage {
    let url = Foundation.URL(string: Url)
    let data = try? Data(contentsOf: url!)
    return UIImage(data: data!)!
}

public extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
//        if hex.hasPrefix("#") {
//            let index = hex.index(hex.startIndex, offsetBy: 1)
//            hex = hex.substring(from: index)
//        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

public func rgbaToUIColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

public func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

public func stringFromDate(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date as Date)
}

public func dateFromString(date: String, format: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    if let date = dateFormatter.date(from: date) {
        return date
    } else {
        return Date(timeIntervalSince1970: 0)
    }
}

public func randomStringWithLength (len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 0 ..< len {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
}

public func timeAgoSinceDate(date: Date, numericDates: Bool) -> String {
    let calendar = Calendar.current
    let unitFlags = Set<Calendar.Component>(arrayLiteral: Calendar.Component.minute, Calendar.Component.hour, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.month, Calendar.Component.year, Calendar.Component.second)
    let now = Date()
    let dateComparison = now.compare(date)
    var earliest: Date
    var latest: Date
    
    switch dateComparison {
    case .orderedAscending:
        earliest = now
        latest = date
    default:
        earliest = date
        latest = now
    }
    
    let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
    
    guard
        let year = components.year,
        let month = components.month,
        let weekOfYear = components.weekOfYear,
        let day = components.day,
        let hour = components.hour,
        let minute = components.minute,
        let second = components.second
        else {
            fatalError()
    }
    
    if (year >= 2) {
        return "\(year)y"
    } else if (year >= 1) {
        if (numericDates){
            return "1y"
        } else {
            return "1y"
        }
    } else if (month >= 2) {
        return "\(month * 4)w"
    } else if (month >= 1) {
        if (numericDates){
            return "4w"
        } else {
            return "4w"
        }
    } else if (weekOfYear >= 2) {
        return "\(weekOfYear)w"
    } else if (weekOfYear >= 1){
        if (numericDates){
            return "1w"
        } else {
            return "1w"
        }
    } else if (day >= 2) {
        return "\(components.day ?? 2)d"
    } else if (day >= 1){
        if (numericDates){
            return "1d"
        } else {
            return "1d"
        }
    } else if (hour >= 2) {
        return "\(hour)h"
    } else if (hour >= 1){
        if (numericDates){
            return "1h"
        } else {
            return "1h"
        }
    } else if (minute >= 2) {
        return "\(minute)m"
    } else if (minute >= 1){
        if (numericDates){
            return "1m"
        } else {
            return "1m"
        }
    } else if (second >= 3) {
        return "\(second)s"
    } else {
        return "now"
    }
    
}

extension UIImageView {
    func setImage(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, placeholderImage: UIImage?) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    self.image = placeholderImage
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                
            }
            }.resume()
    }
    func setImage(urlString: String, contentMode mode: UIViewContentMode = .scaleAspectFit, placeholderImage: UIImage?) {
        guard let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        setImage(url: url, contentMode: mode, placeholderImage: placeholderImage)
    }
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

