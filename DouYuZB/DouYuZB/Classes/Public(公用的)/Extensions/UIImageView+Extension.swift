//
//  UIImageView+Extension.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// 只播放一次GIF图片
    ///
    /// - Parameter imageName: gif图片的名称
    func playGIFImage(_ imageName: String, isRemove finishAnimation: Bool) {
        
        // 1.获取NSData类型
        guard let filePath = Bundle.main.path(forResource: imageName, ofType: "gif") else { return }
        guard let fileData = NSData(contentsOfFile: filePath) else { return }
        
        // 2.根据Data获取CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(fileData, nil) else { return }
        
        // 3.获取gif图片中图片的个数
        let frameCount = CGImageSourceGetCount(imageSource)
        
        // 记录播放时间
        var duration : TimeInterval = 0
        var images = [UIImage]()
        for i in 0..<frameCount {
            // 3.1.获取图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            // 3.2.获取时长
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) ,
                let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary ,
                let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else { continue }
            
            duration += frameDuration.doubleValue
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            // 设置停止播放时现实的图片
            if i == frameCount - 1 {
//                self.image = image
                self.image = UIImage(named: imageName)
            }
        }
        // 4.播放图片
        self.animationImages = images
        // 播放总时间
        self.animationDuration = duration
        // 播放次数, 0为无限循环
        self.animationRepeatCount = 1
        // 开始播放
        self.startAnimating()
        
        if finishAnimation == true {
            self.perform(#selector(removeFromSuperview), with: nil, afterDelay: duration)
        }
    }
    
    
    
    
}
