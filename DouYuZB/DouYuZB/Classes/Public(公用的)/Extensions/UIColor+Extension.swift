//
//  UIColor+Extension.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb : CGFloat) {
        self.init(red: rgb / 255.0, green: rgb / 255.0, blue: rgb / 255.0, alpha: 1.0)
    }
    
    static var random: UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    convenience init(hexString: String) {
        let characterSet = NSCharacterSet.whitespacesAndNewlines
        var cString = hexString.trimmingCharacters(in: characterSet).uppercased()
        
        // String should be 6 or 8 characters
        if (cString.count < 6) {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        // 判断前缀
        if cString.hasPrefix("0X") {
            cString = (cString as NSString).substring(from: 2)
        } else if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        } else if cString.hasPrefix("0#") {
            cString = (cString as NSString).substring(from: 2)
        } else if cString.count != 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        // 从六位数值中找到RGB对应的位数并转换
        var range = NSRange(location: 0, length: 2)
        
        //R、G、B
        let rString = (cString as NSString).substring(with: range)
        range.location = 2;
        let gString = (cString as NSString).substring(with: range)
        range.location = 4;
        let bString = (cString as NSString).substring(with: range)
        // Scan values
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    
}


