//
//  DYBaseViewController.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

private let kNavItemMargin = ws_defultFixSpace + 5


// MARK: - baseViewController 的属性
class DYBaseViewController: UIViewController {
    
    /// 搜索框
    lazy var searchBar: DYSearchBar = {
        let height: CGFloat = 30.0
        let x = ws_defultFixSpace + (navigationItem.leftBarButtonItem?.customView?.width ?? 0) + kNavItemMargin
        let y = ((navigationController?.navigationBar.height ?? 44) - height) * 0.5
        let rightItemW = ws_defultFixSpace + (navigationItem.rightBarButtonItem?.customView?.width ?? 0) + kNavItemMargin
        let width = kScreenWidth - x - rightItemW
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let searchBar = DYSearchBar(rightImage: "cm_nav_richscan", frame: frame)
        searchBar.myDelegate = self
        searchBar.placeholderSize = 13.0
//        searchBar.placeholderColor = .red
        let placeholderList = ["uzi", "dota", "韦神", "LCK", "不求人"]
        searchBar.placeholderList = placeholderList
        searchBar.defaultChangePlaceholderTime = 3.0
        return searchBar
    }()
    
    
}

// MARK: - 生命周期方法
extension DYBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI
        setupUI()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
}


// MARK: - 设置UI
extension DYBaseViewController {
    private func setupUI() {
        // 设置导航栏
        setupNav()
        
    }
    
    /// 设置导航栏
    func setupNav() {
        
        // 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem.eyeFish(target: self, action: #selector(eyeFishClick))
        
        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "cm_nav_history", highImageName: "cm_nav_history", target: self, action: #selector(watchingHistory))
        
        // 中间
//        navigationItem.titleView = searchBar
        navigationController?.navigationBar.addSubview(searchBar)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - 搜索框代理方法
extension DYBaseViewController: DYSearchBarDelegate {
    /// 搜索框右边图标点击
    func searchBar(_ searchBar: DYSearchBar, didSelected rightView: UIView?) {
        debugPrint("scan")
    }
    /// 开始编辑
    func searchBarDidBeginEditing(_ searchBar: DYSearchBar) {
        debugPrint("searchBarDidBeginEditing")
    }
    
    
}
