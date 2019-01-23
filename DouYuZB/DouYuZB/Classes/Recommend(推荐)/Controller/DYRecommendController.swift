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
        /// 添加通知
        // TabBarButton被重复点击的通知
        NotificationCenter.default.addObserver(self, selector: #selector(dropdownRefresh), name: NSNotification.Name(rawValue:DYTabBarButtonDidRepeatClickNotification), object: nil)
        // TitleButton被重复点击的通知
        NotificationCenter.default.addObserver(self, selector: #selector(dropdownRefresh), name: NSNotification.Name(rawValue:DYTitleButtonDidRepeatClickNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 移除通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: DYTabBarButtonDidRepeatClickNotification), object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
}

// MARK: - 设置UI
extension DYRecommendController {
    private func setupUI() {
        self.edgesForExtendedLayout = UIRectEdge.bottom
        // 设置内容view
        setupContentView()
    }
    
    /// 创建内容控制器
    func setupContentView() {
//        let frame = CGRect
        
        let titles = ["分类", "推荐", "全部", "LOL", "王者荣耀", "绝地求生", "穿越火线", "DNF", "刺激战场", "CF手游", "DOTA2", "主机游戏", "炉石传说", "CS:GO", "堡垒之夜"]
        
        var controllers: [UIViewController] = []
        for _ in titles {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.random()
            controllers.append(vc)
        }
        
        let contentView = DYPageView(frame: view.bounds, titles: titles, controllers: controllers, titleColor: UIColor(rgb: 224), titleColor: .white, underLine: true, selectTitle: 1.25)
        contentView.topTitleViewHeight = 44
        view.addSubview(contentView)
        
    }
    
}


// MARK: - 通知事件处理
extension DYRecommendController {
    @objc private func dropdownRefresh() {
        debugPrint("dropdownRefresh")
    }
}


