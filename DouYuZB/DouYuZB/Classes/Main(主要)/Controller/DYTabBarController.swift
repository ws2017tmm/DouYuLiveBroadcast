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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orange
        tabBar.barTintColor = UIColor.white
//        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
//        let tabBar = DYTabBar()
//        self.setValue(tabBar, forKeyPath: "tabBar")
//
//        self.children
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    @objc func tabBarButtonClick(_ tabBarButton: UIControl) {
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
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else {
            return
        }
        
        item.selectedImage = UIImage(named: "123")?.withRenderingMode(.alwaysOriginal)
        
    }
    
    
//    func gifImage(_ imageName: String) -> UIImage {
//        let str = Bundle.main.path(forResource: imageName, ofType: "gif")
//
//        let url = URL(fileURLWithPath: str!)
//
//
//        do {
//            let imageData = try Data(contentsOf: url)
//            let image = UIImage.sd_animatedGIF(with: imageData)
//            return image!
//        } catch {
//            print(error)
//        }
//
//        return UIImage(named: imageName)!
//    }

}
