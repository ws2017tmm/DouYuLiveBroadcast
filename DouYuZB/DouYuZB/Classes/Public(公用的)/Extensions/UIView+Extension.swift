//
//  UIView+Extension.swift
//  010-qq音乐播放器
//
//  Created by StevenWu on 2018/12/14.
//  Copyright © 2018 StevenWu. All rights reserved.
//

import Foundation
import UIKit

/// MARK - UIView
extension UIView {
    
    // MARK: - 常用位置属性
    public var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set(newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    public var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var right:CGFloat {
        get {
            return self.x + self.width
        }
    }
    
    public var bottomY:CGFloat {
        get {
            return self.y + self.height
        }
    }
    
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    
    public var origin:CGPoint {
        get {
            return self.frame.origin
        }
        
        set(newOrigin) {
            self.frame.origin = newOrigin
        }
    }
    
    public var size:CGSize {
        get {
            return self.frame.size
        }
        
        set(newSize) {
            self.frame.size = newSize
        }
    }
    
}

