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
    
    // MARK: - 获取颜色的rgb值
    //pragma MARK: - 获取red
    public var ws_red: CGFloat {
        get {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return r
        }
    }
    
    //pragma MARK: - 获取green
    public var ws_green: CGFloat {
        get {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return g
        }
    }
    
    //pragma MARK: - 获取blue
    public var ws_blue: CGFloat {
        get {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return b
        }
    }
    
    /// 两个颜色值互换
    ///
    /// - Parameters:
    ///   - start: 起始颜色值
    ///   - end: 结束颜色值
    /// - Returns: 返回元组(开始颜色值的变化,结束颜色值的变化)
    class func exchangeColor(startColor: UIColor, endColor: UIColor, progress: CGFloat) -> (startProgressColor: UIColor, endProgressColor: UIColor) {
        // 1.拿到当前选中的颜色值
        let startRed = startColor.ws_red * 255.0
        let startGreen = startColor.ws_green * 255.0
        let startBlue = startColor.ws_blue * 255.0
        
        // 2.非选中的颜色值
        let endRed = endColor.ws_red * 255.0
        let endGreen = endColor.ws_green * 255.0
        let endBlue = endColor.ws_blue * 255.0
        
        // 3.颜色值的变化范围
        let rangeRed = (endRed - startRed) * progress
        let rangeGreen = (endGreen - startGreen) * progress
        let rangeBlue = (endBlue - startBlue) * progress
        
        let startProgressColor = UIColor(red: startRed+rangeRed, green: startGreen+rangeGreen, blue: startBlue+rangeBlue, alpha: 1)
        let endProgressColor = UIColor(red: endRed-rangeRed, green: endGreen-rangeGreen, blue: endBlue-rangeBlue, alpha: 1)
        
        return (startProgressColor, endProgressColor)
    }
    
    
    
}


