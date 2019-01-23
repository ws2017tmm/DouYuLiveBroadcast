//
//  DYConst.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/18.
//  Copyright © 2019 StevenWu. All rights reserved.
//  全局的常量

import Foundation
import UIKit

// MARK: - 通知
/// TabBarButton被重复点击的通知
let DYTabBarButtonDidRepeatClickNotification = "DYTabBarButtonDidRepeatClickNotification"
/// TitleButton被重复点击的通知
let DYTitleButtonDidRepeatClickNotification = "DYTitleButtonDidRepeatClickNotification"


// MARK: - 常量
/// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height
/// statusBar的高度(20和44)
let kStatusbarHeight = UIApplication.shared.statusBarFrame.height


/// 导航栏left\rightItem边缘的间距
//var kNavItemEdgeMargin: CGFloat {
//    get {
//        if kScreenWidth >= 414 {
//            return 20.0
//        } else {
//            return 16.0
//        }
//    }
//}

/// 导航栏两个Item之间的间距
//var kSpaceBetweenNavItems: CGFloat {
//    get {
//        if kScreenWidth >= 414 {
//            return 10.0
//        } else {
//            return 8.0
//        }
//    }
//}



