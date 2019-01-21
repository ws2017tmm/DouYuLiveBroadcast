//
//  DYBaseViewController.swift
//  DouYuZB
//
//  Created by 李响 on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

// MARK: - 生命周期方法
class DYBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    

    

}

// MARK: - 设置UI
extension DYBaseViewController {
    private func setupUI() {
        setupNav()
    }
    
    /// 设置导航栏
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.eyeFish(target: self, action: #selector(eyeFishClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "cm_nav_history", highImageName: "cm_nav_history", size: CGSize(width: 23, height: 23), target: self, action: #selector(watchingHistory))
    }
    
    
    
    
}

// MARK: - 按钮的点击事件
extension DYBaseViewController {
    /// 鱼眨眼睛点击
    @objc func eyeFishClick() {
        debugPrint("eyeFishClick")
    }
    
    /// 观看历史点击
    @objc func watchingHistory() {
        debugPrint("watchingHistory")
    }
    
}
