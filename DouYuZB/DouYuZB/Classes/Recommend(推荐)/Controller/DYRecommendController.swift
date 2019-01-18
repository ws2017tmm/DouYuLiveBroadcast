//
//  DYRecommendController.swift
//  DouYuZB
//
//  Created by 李响 on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

class DYRecommendController: UIViewController {

    
    
    

    

}

// MARK: - 生命周期方法
extension DYRecommendController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "推荐"
        // Do any additional setup after loading the view.
        
        
        
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
