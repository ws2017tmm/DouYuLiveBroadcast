//
//  DYRecommendController.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

class DYRecommendController: DYBaseViewController {

    
    
    

    

}

// MARK: - 生命周期方法
extension DYRecommendController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "推荐"
        
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem.eyeFish(target: self, action: #selector(eyeFishClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "cm_nav_history", highImageName: "cm_nav_history", size: CGSize(width: 23, height: 23), target: self, action: #selector(eyeFishClick))
        
    }
    
    @objc func eyeFishClick() {
        debugPrint("eyeFishClick")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(dropdownRefresh), name: NSNotification.Name(rawValue:DYTabBarButtonDidRepeatClickNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 移除通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: DYTabBarButtonDidRepeatClickNotification), object: nil)
    }
    
}



// MARK: - 通知事件处理
extension DYRecommendController {
    @objc private func dropdownRefresh() {
        debugPrint("dropdownRefresh")
    }
}
