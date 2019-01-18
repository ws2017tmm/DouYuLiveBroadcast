//
//  UIBarButtonItem+Extension.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    // 便利构造函数: 1> convenience开头 2> 在构造函数中必须明确调用一个设计的构造函数(self)
    convenience init(imageName : String, highImageName : String = "", size : CGSize = CGSize.zero, target: Any?, action: Selector)  {
        // 1.创建UIButton
        let btn = UIButton()
        btn.addTarget(target, action: action, for: .touchUpInside)
        // 2.设置btn的图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        // 3.设置btn的尺寸
        if size == CGSize.zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        // 4.创建UIBarButtonItem
        self.init(customView : btn)
    }
    
    /// 左边眨眼睛的logo
    class func eyeFish(target: Any?, action: Selector) -> UIBarButtonItem {
        
        let imageView  = UIImageView()
        imageView.size = CGSize(width: 40, height: 40)
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: target, action: action)
        imageView.addGestureRecognizer(tap)
        
        var animationImages = [UIImage]()
        for i in 1...9 {
            let imageName = "image_default_eye" + "\(i)"
            
            guard let image = UIImage(named: imageName) else { continue }
            animationImages.append(image)
        }

        
        imageView.animationImages = animationImages
        imageView.animationDuration = 0.8
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
//        imageView.image = UIImage(named: "image_default_eye1")
        
        let item = UIBarButtonItem(customView: imageView)
        return item
    }
    
}

