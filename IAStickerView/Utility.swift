//
//  Utility.swift
//  IASticker_View_Demo
//
//  Created by Md Abu Sufian on 28/11/17.
//  Copyright © 2017 Md Abu Sufian. All rights reserved.
//

import UIKit

class Utility: NSObject {

}

extension UIColor {
    class func colorFromRGB(colorHexString: String) -> UIColor {
        let str = "#" + colorHexString + "ff"
        return UIColor.init(hexString: str)!
    }
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
