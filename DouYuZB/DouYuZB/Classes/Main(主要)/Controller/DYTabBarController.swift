//
//  DYTabBarController.swift
//  DouYuZB
//
//  Created by 李响 on 2019/1/17.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit
import SDWebImage

class DYTabBarController: UITabBarController {
    
    /// gif图片数组
    lazy var gifImageList: [String] = {
        var list = ["gif_tabLive", "gif_tabYule", "gif_tabFocus", "gif_tabYuba", "gif_tabDiscovery"]
        return list
    }()
    
    /// 当前的索引
    var currentIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orange
        tabBar.barTintColor = UIColor.white
//        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 给tabBarItem额外添加点击事件
        guard let btnClass = NSClassFromString("UITabBarButton") else { return }
        
        for view in tabBar.subviews {
            if view.classForCoder == btnClass {
                if let control = view as? UIControl {
                    debugPrint(control)
                    control.removeTarget(self, action: #selector(self.tabBarButtonClick(_:)), for: .touchUpInside)
                    control.addTarget(self, action: #selector(self.tabBarButtonClick(_:)), for: .touchUpInside)
                }
            }
        }
    }
    
    // tabBarItem的点击
    @objc func tabBarButtonClick(_ tabBarButton: UIControl) {
    
        // 当前点击同一个item
        if currentIndex == selectedIndex {
            return
        }
        guard let swappableClass = NSClassFromString("UITabBarSwappableImageView") else { return }
        
        for view in tabBarButton.subviews {
            if view.classForCoder == swappableClass {
                if let imageView = view as? UIImageView {
                    
                    let gifImageView = UIImageView()
                    imageView.addSubview(gifImageView)
                    gifImageView.frame = imageView.bounds
                    
                    let imageName = gifImageList[selectedIndex]
                    gifImageView.playGIFImage(imageName, isRemove: true)
                }
            }
        }
    }
    
    // MARK: - tabBar 代理
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else {
            return
        }
        // 记录当前index
        currentIndex = selectedIndex
        
        // 当前点击相同的item
        if index == selectedIndex {
            NotificationCenter.default.post(name: NSNotification.Name(DYTabBarButtonDidRepeatClickNotification), object: nil)
        }
    }
    

}
