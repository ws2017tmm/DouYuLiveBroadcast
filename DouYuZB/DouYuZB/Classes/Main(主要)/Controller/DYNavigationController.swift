//
//  DYNavigationController.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/17.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

class DYNavigationController: UINavigationController {
    
    /// 自定义导航栏
//    var navBar: DYNavigationBar = {
//
//        let navBar = DYNavigationBar()
//
//        return navBar
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sx_defultFixSpace = 10
        
        // 替换系统的navigationBar
//        self.setValue(navBar, forKeyPath: "navigationBar")
        
        
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage.image(UIColor(r: 253, g: 129, b: 82)), for: .default)
        
        
    }
    

}


