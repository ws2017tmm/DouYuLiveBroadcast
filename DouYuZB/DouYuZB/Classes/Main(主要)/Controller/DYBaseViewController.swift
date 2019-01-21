//
//  DYBaseViewController.swift
//  DouYuZB
//
//  Created by 李响 on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

let kNavItemMargin = kNavItemEdgeMargin + 5


// MARK: - base 的属性
class DYBaseViewController: UIViewController {
    
    lazy var searchBar: DYSearchBar = {
        let x = kNavItemEdgeMargin + (navigationItem.leftBarButtonItem?.customView?.width ?? 0) + kNavItemMargin
        let rightItemW = kNavItemEdgeMargin + (navigationItem.rightBarButtonItem?.customView?.width ?? 0) + kNavItemMargin
        let width = kScreenWidth - x - rightItemW
        let frame = CGRect(x: x, y: 0, width: width, height: 30)
        
//        let searchBar = DYSearchBar.searchBar(rightImage: "cm_nav_richscan", frame: frame)
        let searchBar = DYSearchBar(rightImage: "cm_nav_richscan", frame: frame)
        searchBar.myDelegate = self
        
        return searchBar
    }()
    
    
    
    
}

// MARK: - 生命周期方法
extension DYBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
}


// MARK: - 设置UI
extension DYBaseViewController {
    private func setupUI() {
        setupNav()
    }
    
    /// 设置导航栏
    private func setupNav() {
        // 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem.eyeFish(target: self, action: #selector(eyeFishClick))
//        navigationController?.navigationBar.addSubview(<#T##view: UIView##UIView#>)
        
        
        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "cm_nav_history", highImageName: "cm_nav_history", target: self, action: #selector(watchingHistory))
        
        // 中间
        navigationItem.titleView = searchBar
        
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
