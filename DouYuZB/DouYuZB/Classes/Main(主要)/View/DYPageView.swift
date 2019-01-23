//
//  DYPageView.swift
//  DouYuZB
//
//  Created by 李响 on 2019/1/22.
//  Copyright © 2019 StevenWu. All rights reserved.
//  分类切换滚动视图

import UIKit

//MARK: - 常量
/// 顶部标题下划线的高度
private let kTopUnderLineHeight: CGFloat = 1.5
private let kTopButtonLeftMargin: CGFloat = 10
private let KTopButtonsMargin: CGFloat = kTopButtonLeftMargin * 2

// MARK: - 属性 + 构造方法
class DYPageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(topTitleScrollView)
        self.addSubview(contentCollectionView)
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
    convenience init(frame: CGRect ,
                     titles: [String],
                     controllers: [UIViewController],
                     titleFont: CGFloat = 15.0,
                     titleColor unSelect: UIColor = UIColor.black,
                     titleColor select: UIColor = UIColor.orange,
                     underLine isShow: Bool = true,
                     selectTitle scale: CGFloat = 1.0) {
        self.init(frame: frame)
        
        self.titleFont = titleFont
        self.unSelectTitleColor = unSelect
        self.selectTitleColor = select
        self.isShowUnderLine = isShow
        self.selectTitleScale = scale
        
        defer {
            self.titles = titles
            self.controllers = controllers
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 顶部标题scrollView
    private lazy var topTitleScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.orange
        
        return scrollView
    }()
    
    /// 中间内容View
    private lazy var contentCollectionView: UICollectionView = {
        /// 流水布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        /// frame随便写,再layoutSubViews重新布局
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.scrollsToTop = false
//        collectionView.dataSource = self
//        collectionView.delegate = self
        
        return collectionView
    }()
    
    /// 顶部标题字体的大小
    private var titleFont: CGFloat = 15.0
    
    /// 顶部标题未选中的颜色
    private var unSelectTitleColor: UIColor = UIColor.black
    
    /// 顶部标题选中的颜色
    private var selectTitleColor: UIColor = UIColor.orange
    
    /// 顶部标题是否显示下划线
    private var isShowUnderLine: Bool = true
    
    /// 当前选中第几个
    private var currentSelectdIndex : Int = 0
    
    /// 顶部标题下划线
    lazy var topScrollUnderLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = selectTitleColor
        return scrollLine
    }()
    
    /// 顶部标题选中放大的倍数
    private var selectTitleScale: CGFloat = 1.0
    
    /// 默认选中第0个
    private var defaultPage: Int = 0
    
    /// 所有顶部标题按钮的数组
    lazy private var topTitleButtons = [UIButton]()
    
    /// 顶部titleView的高度
    var topTitleViewHeight: CGFloat = 35 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 头标题
    var titles: [String]? {
        didSet {
            // 创建头标题View
            createTopTitleView()
        }
    }
    
    /// 每一个标题对对应的控制权
    var controllers: [UIViewController]? {
        didSet {
            /// 创建内容View
            createContentView()
        }
    }
    
    
}


//MARK: - 创建TitleView和ContentView
extension DYPageView {
    /// 创建头标题View
    private func createTopTitleView() {
        
        /// 创建buttons
        createTopTitleViewButtons()
        
        /// 创建按钮的下划线
        if isShowUnderLine {
            createTopTitleViewUnderLine()
        }
        
        
        
        
    }
    
    //pragma MARK: - 创建标题View里面的buttons
    func createTopTitleViewButtons() {
        guard let titles = titles else { return }
        for (index,title) in titles.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.setTitleColor(unSelectTitleColor, for: .normal)
            button.setTitleColor(selectTitleColor, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
            button.tag = index
            button.addTarget(self, action: #selector(topTitleButtonClick), for: .touchUpInside)
            topTitleButtons.append(button)
            topTitleScrollView.addSubview(button)
        }
    }
    
    //pragma MARK: - 创建标题view的下划线
    func createTopTitleViewUnderLine() {
        topTitleScrollView.addSubview(topScrollUnderLine)
    }
    
    
    
    /// 创建内容View
    private func createContentView() {
        
    }
    
    
}

//MARK: - 顶部按钮的点击事件
extension DYPageView {
    @objc func topTitleButtonClick(_ button: UIButton) {
        
        // 1.判断是否点击的相同的按钮
        if button.tag == currentSelectdIndex {
            // 发送通知，点击的是相同的按钮
            NotificationCenter.default.post(name: NSNotification.Name(DYTitleButtonDidRepeatClickNotification), object: nil)
        }
        
        // 2.获取之前的button
        let oldButton = topTitleButtons[currentSelectdIndex]
        
        // 3.切换颜色，变更字体大小
        oldButton.isSelected = false
        oldButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
        button.isSelected = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: titleFont*selectTitleScale)
        setNeedsLayout()
        
        // 4.记录两个index的差值
        let offsetIndex = Double(abs(button.tag - currentSelectdIndex))
        
        // 5.保存最新的下标值
        currentSelectdIndex = button.tag
        
        if isShowUnderLine {
            // 滚动条滚动到合适的位置(宽度自适应)
            UIView.animate(withDuration: 0.1*offsetIndex) {
                self.topScrollUnderLine.frame = CGRect(x: button.x, y: self.topScrollUnderLine.y, width: button.width, height: self.topScrollUnderLine.height)
            }
        }
        
    }
}


// MARK: - 布局控件frame
extension DYPageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// topTitleScrollView的位置
        topTitleScrollView.frame = CGRect(x: 0, y: 0, width: self.width, height: topTitleViewHeight)
        
        /// 布局topTitleScrollView里面button的位置
        var previousButton: UIButton = UIButton()
        
        /// 布局按钮的位置
        for (index, button) in topTitleButtons.enumerated() {
            button.sizeToFit()
            var x : CGFloat
            if index == 0 {
                x = kTopButtonLeftMargin
            } else {
                x = previousButton.right + KTopButtonsMargin
            }
            let y = (topTitleScrollView.height - button.height) * 0.5
            button.frame = CGRect(x: x, y: y, width: button.width, height: button.height)
            previousButton = button
            
            if index == (topTitleButtons.count-1) {
                /// topTitleScrollView的滚动范围
                topTitleScrollView.contentSize = CGSize(width: button.right + kTopButtonLeftMargin, height: 0)
            }
        }
        
        let button = topTitleButtons[currentSelectdIndex]
        /// 布局下滑线的位置
        topScrollUnderLine.frame = CGRect(x: button.x, y: button.bottomY, width: button.width, height: kTopUnderLineHeight)
        
        
        
        
        
        
        
    }
}
