//
//  DYRecommendController.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

// MARK: - 控制器属性
class DYRecommendController: DYBaseViewController {

    
    
    

    

}

// MARK: - 生命周期方法
extension DYRecommendController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        
        
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

// MARK: - 设置UI
extension DYRecommendController {
    func setupUI() {
        title = "推荐"
    }
    
}


// MARK: - 通知事件处理
extension DYRecommendController {
    @objc private func dropdownRefresh() {
        debugPrint("dropdownRefresh")
    }
}


