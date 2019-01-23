//
//  DYPageView.swift
//  DouYuZB
//
//  Created by 李响 on 2019/1/22.
//  Copyright © 2019 StevenWu. All rights reserved.
//  分类切换滚动视图

import UIKit



// MARK: - 属性 + 构造方法
class DYPageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 快速创建pageView
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - titles: 头标题
    ///   - controllers: 子控制器
    ///   - titleFont: 标题字体的大小(默认15)
    ///   - unSelect: 未选中的颜色(默认黑色)
    ///   - select: 选中的颜色(默认橘色)
    ///   - isShow: 是否展示下划线(默认展示)
    ///   - scale: 选择标题放大的倍数默(默认不放大1.0)
    convenience init(frame: CGRect ,titles: [String], controllers: [UIViewController], titleFont: CGFloat = 15.0, titleColor unSelect: UIColor = UIColor.black, titleColor select: UIColor = UIColor.orange, underLine isShow: Bool = true, selectTitle scale: CGFloat = 1.0) {
        self.init(frame: frame)
        
        self.titleFont = titleFont
        self.unSelectTitleColor = unSelect
        self.selectTitleColor = select
        self.isShowUnderLine = isShow
        self.selectTitleScale = scale
        
        self.titles = titles
        self.controllers = controllers
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 顶部标题字体的大小
    private var titleFont: CGFloat = 15.0
    
    /// 顶部标题未选中的颜色
    private var unSelectTitleColor: UIColor = UIColor.black
    
    /// 顶部标题选中的颜色
    private var selectTitleColor: UIColor = UIColor.orange
    
    /// 顶部标题是否显示下划线
    private var isShowUnderLine: Bool = true
    
    /// 顶部标题选中放大的倍数
    private var selectTitleScale: CGFloat = 1.0
    
    /// 顶部titleView
    private var topTitleView: UIScrollView?
    
    /// 顶部titleView的高度
    var titleViewHeight: CGFloat = 30 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 头标题
    var titles: [String]? {
        didSet {
            // 创建头标题View
            createTitleView()
        }
    }
    
    /// 内容view
    private var contentView: UICollectionView?
    
    /// 每一个标题对对应的控制权
    var controllers: [UIViewController]? {
        didSet {
            /// 创建内容View
            createContentView()
        }
    }
    

}



//MARK: - 私有方法
extension DYPageView {
    /// 创建头标题View
    private func createTitleView() {
        
        let titleView = UIScrollView()
        
        guard let titles = titles else {
            return
        }
        for title in titles {
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            
        }
        
        
        
        
        
        
        
    }
    
    /// 创建内容View
    private func createContentView() {
        
    }
    
    
}




// MARK: - 构造方法
extension DYPageView {
    
}
