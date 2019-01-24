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
private let KTopButtonsMargin: CGFloat = kTopButtonLeftMargin
private let kContentCellID = "kContentCellID"

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
        if scale < 1.0 || scale > 1.5 {
            self.selectTitleScale = 1.0
        } else {
            self.selectTitleScale = scale
        }
        
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
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.random
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        
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
    private var defaultPage: Int = 0 {
        didSet {
            // 标题
            let button = topTitleButtons[defaultPage]
            topTitleButtonClick(button)
            // 内容
            collectionViewStartOffsetX = self.width * CGFloat(defaultPage)
            contentCollectionView.setContentOffset(CGPoint(x: collectionViewStartOffsetX, y: 0), animated: false)
            
            currentSelectdIndex = defaultPage
            
        }
    }
    
    /// 所有顶部标题按钮的数组
    lazy private var topTitleButtons = [UIButton]()
    
    /// 当前collectionView的偏移量
    private var collectionViewStartOffsetX: CGFloat = 0
    
    /// 点击标题按钮的时候,不需要执行scrollViewDidScroll代理方法
    private var isForbidScroll: Bool = true
    
    /// 顶部titleView的高度
    var topTitleViewHeight: CGFloat = 40 {
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
    
    /// 当前下划线的x
    var currentUnderLineCenterX: CGFloat = 0
    /// 当前下划线的width
    var currentUnderLineWidth: CGFloat = 0

}


//MARK: - 创建TitleView和ContentView
extension DYPageView {
    /// 创建头标题View
    private func createTopTitleView() {
        /// scrollView
        addSubview(topTitleScrollView)
        
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
        currentSelectdIndex = defaultPage
    }
    
    //pragma MARK: - 创建标题view的下划线
    func createTopTitleViewUnderLine() {
        topTitleScrollView.addSubview(topScrollUnderLine)
    }
    
    
    //pragma MARK: - 创建内容View
    private func createContentView() {
        addSubview(contentCollectionView)
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout(布局)
extension DYPageView: UICollectionViewDelegateFlowLayout {
    /// 每个item的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.width, height: self.height - topTitleViewHeight)
    }
}

//MARK: - UICollectionViewDataSource
extension DYPageView: UICollectionViewDataSource {
    /// 每组多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers?.count ?? 0
    }
    
    /// 每个cell显示什么
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        // 2.给Cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        guard let childVc = controllers?[(indexPath as NSIndexPath).item] else {
            return cell
        }
        
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension DYPageView: UICollectionViewDelegate {
    
    //pragma MARK: - scrollView代理
    // 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 当前的偏移量
        collectionViewStartOffsetX = scrollView.contentOffset.x
        
        // 手动滚动,scrollView可以滚动
        isForbidScroll = false
    }
    
    // 滚动中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScroll { return }
        
        
        let (sourceIndex, targetIndex, progress) = getIndexAndProgress(scrollView)
        
        changeTitleViewState(scrollView: scrollView, index: sourceIndex, index: targetIndex, progress: progress)
        
    }
    
    // 停止滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /// 改变当前选中的index
        currentSelectdIndex = Int(scrollView.contentOffset.x / scrollView.width)
        currentUnderLineCenterX = topScrollUnderLine.centerX
        currentUnderLineWidth = topScrollUnderLine.width
        
        // 只有手动拖拽，才调用scrollViewDidScroll
        isForbidScroll = true
        
        topTitleScrollViewScroll(target: topTitleButtons[currentSelectdIndex])
        debugPrint("scrollViewDidEndDecelerating")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint("scrollViewDidEndDragging")

        let (sourceIndex, targetIndex, progress) = getIndexAndProgress(scrollView)
        
        changeTitleViewState(scrollView: scrollView, index: sourceIndex, index: targetIndex, progress: progress)
        
        topTitleScrollViewScroll(target: topTitleButtons[currentSelectdIndex])

    }
}

//MARK: - 标题ScrollView和内容collecionView联动
extension DYPageView {
    //pragma MARK: - 顶部按钮的点击事件
    @objc func topTitleButtonClick(_ button: UIButton) {
        
        // 1.判断是否点击的相同的按钮
        if button.tag == currentSelectdIndex {
            // 发送通知，点击的是相同的按钮
            NotificationCenter.default.post(name: NSNotification.Name(DYTitleButtonDidRepeatClickNotification), object: nil)
            return
        }
        
        // 2.获取之前的button
        let oldButton = topTitleButtons[currentSelectdIndex]
        
        // 3.改变标题按钮的状态
        changeTitleViewState(sourceButton: oldButton, targetButton: button)
        
        // 4.collectionView滚动
        let point = CGPoint(x: contentCollectionView.width * CGFloat(button.tag), y: 0)
        contentCollectionView.setContentOffset(point, animated: true)
        
        // 5.保存最新的下标值
        currentSelectdIndex = button.tag
    }
    
    //pragma MARK: - 改变标题scrollView的一些状态
    private func changeTitleViewState(sourceButton: UIButton, targetButton: UIButton, animation: Bool = true) {
        
        // 切换颜色，变更字体大小
        sourceButton.isSelected = false
        sourceButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
        sourceButton.setTitleColor(unSelectTitleColor, for: .normal)
        sourceButton.setTitleColor(selectTitleColor, for: .selected)
        
        targetButton.isSelected = true
        targetButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFont*selectTitleScale)
        targetButton.setTitleColor(unSelectTitleColor, for: .normal)
        targetButton.setTitleColor(selectTitleColor, for: .selected)
        targetButton.titleLabel?.sizeToFit()
        
        // 记录两个index的差值
        let offsetIndex = Double(abs(targetButton.tag - currentSelectdIndex))
        
        if isShowUnderLine {
            // 计算下划线的frame
            let centerX = targetButton.centerX
            let width = targetButton.titleLabel?.width ?? targetButton.width
            
            if animation {
                // 滚动条滚动到合适的位置(宽度自适应)
                UIView.animate(withDuration: 0.1*offsetIndex) {
                    self.topScrollUnderLine.width = width
                    self.topScrollUnderLine.centerX = centerX
                }
            } else {
                self.topScrollUnderLine.width = width
                self.topScrollUnderLine.centerX = centerX
            }
        }
        
        // 标题scrollView跟着滚动
        topTitleScrollViewScroll(target: targetButton)
    }
    
    //pragma MARK: - 当前scrollView算出源Index和目标Index和进度
    private func getIndexAndProgress(_ scrollView: UIScrollView) -> (Int, Int, CGFloat) {
        // 滚动的进度
        var progress: CGFloat = 0.0// 滚动的进度
        // 源index
        var sourceIndex: Int = 0
        // 目标index
        var targetIndex: Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.width
        // 滚动的偏移(可正可负)
        let offsetX = currentOffsetX - collectionViewStartOffsetX
        
        // 判断左滑还是右滑
        if offsetX >= 0 { // 左滑
            // 1.计算progress
            progress = offsetX / scrollView.width
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex == titles?.count {
                targetIndex = (titles?.count)! - 1
            }
            // 4.如果完全划过去
            if Int(currentOffsetX) % Int(scrollViewW) == 0 && currentOffsetX > 1 {
                targetIndex = sourceIndex
            }
            debugPrint(sourceIndex,currentOffsetX)
        } else { // 右滑
            progress = -offsetX / scrollView.width
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            
            if targetIndex == -1 {
                targetIndex = 0
            }
            // 4.如果完全划过去
            if Int(currentOffsetX) % Int(scrollViewW) == 0 {
                progress = 1
                sourceIndex = targetIndex
            }
        }
        return (sourceIndex, targetIndex, progress)
    }
    
    //pragma MARK: - 改变标题scrollView的一些状态
    func changeTitleViewState(scrollView: UIScrollView,index source: Int, index target: Int, progress: CGFloat) {
        if progress == 0 {
            return
        }
        // 取出当前选中和target对应的button
        let sourceButton = topTitleButtons[source]
        let targetButton = topTitleButtons[target]
        
        
        // 改变字体大小
//        let scaleBigFont = progress * (selectTitleScale - 1) * titleFont
//        let scaleSmallFont = (1-progress) * (selectTitleScale - 1) * titleFont
//        currentButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFont + scaleSmallFont)
//        targetButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFont + scaleBigFont)
//        currentButton.titleLabel?.sizeToFit()
//        targetButton.titleLabel?.sizeToFit()
        
        // 下划线移动的位置
        // 计算下划线的frame
        if source == target {
            let currentOffsetX = scrollView.contentOffset.x
            let offsetX = currentOffsetX - collectionViewStartOffsetX
            if offsetX >= 0 { // 左滑
                let button = topTitleButtons[target-1]
                button.isSelected = false
                button.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
                button.setTitleColor(unSelectTitleColor, for: .normal)
                button.setTitleColor(selectTitleColor, for: .selected)
            } else { // 右滑
                let button = topTitleButtons[target+1]
                button.isSelected = false
                button.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
                button.setTitleColor(unSelectTitleColor, for: .normal)
            }
            targetButton.isSelected = true
            targetButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFont*selectTitleScale)
            targetButton.setTitleColor(selectTitleColor, for: .selected)
            targetButton.setTitleColor(unSelectTitleColor, for: .normal)
            targetButton.titleLabel?.sizeToFit()
            if isShowUnderLine {
                topScrollUnderLine.width = targetButton.titleLabel?.width ?? targetButton.width
                topScrollUnderLine.centerX = targetButton.centerX
            }
            currentSelectdIndex = target
//            debugPrint(sourceIndex,targetIndex)
            return
        } else {
            if isShowUnderLine {
                let centerX = progress * (targetButton.centerX - sourceButton.centerX) + currentUnderLineCenterX
                let width = progress * (targetButton.titleLabel!.width - sourceButton.titleLabel!.width) + currentUnderLineWidth
                topScrollUnderLine.width = width
                topScrollUnderLine.centerX = centerX
//            debugPrint(targetIndex,centerX)
            }
        }
        
        // 字体颜色渐变
        // 1.拿到当前选中的颜色值
        let fromRed = selectTitleColor.ws_red * 255.0
        let fromGreen = selectTitleColor.ws_green * 255.0
        let fromBlue = selectTitleColor.ws_blue * 255.0
        
        // 2.非选中的颜色值
        let toRed = unSelectTitleColor.ws_red * 255.0
        let toGreen = unSelectTitleColor.ws_green * 255.0
        let toBlue = unSelectTitleColor.ws_blue * 255.0
        
        // 3.颜色值的变化范围
        let rangeRed = (toRed - fromRed) * progress
        let rangeGreen = (toGreen - fromGreen) * progress
        let rangeBlue = (toBlue - fromBlue) * progress
        
        // 3.选中的颜色值 -> 非选中的颜色值
        // 3.1转变的进度
        sourceButton.isSelected = false
        sourceButton.setTitleColor(UIColor(r: fromRed+rangeRed, g: fromGreen+rangeGreen, b: fromBlue+rangeBlue), for: .normal)
//        sourceButton.setTitleColor(selectTitleColor, for: .selected)
        sourceButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
        
        targetButton.isSelected = true
        targetButton.setTitleColor(UIColor(r: toRed-rangeRed, g: toGreen-rangeGreen, b: toBlue-rangeBlue), for: .selected)
//        targetButton.setTitleColor(unSelectTitleColor, for: .normal)
        targetButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFont*selectTitleScale)

        // 记录index
        currentSelectdIndex = target
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //pragma MARK: - 顶部标题scrollViewg滚动,保证每次点击的按钮在屏幕最中间
    private func topTitleScrollViewScroll(target button: UIButton) {
        // 1.拿到当前选中的button
        if button.centerX < topTitleScrollView.centerX {
            topTitleScrollView.setContentOffset(CGPoint.zero
                , animated: true)
            return
        }
        // 顶部scrollView应该移动的距离
        let offsetX = abs(topTitleScrollView.centerX - button.centerX)
        
        // 最大的位移
        let maxOffsetX = topTitleScrollView.contentSize.width - topTitleScrollView.width
        
        if maxOffsetX > offsetX {
            topTitleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        } else {
            topTitleScrollView.setContentOffset(CGPoint(x: maxOffsetX, y: 0), animated: true)
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
            button.frame = CGRect(x: x, y: y, width: button.width * selectTitleScale + 10, height: button.height)
            previousButton = button
            
            if index == (topTitleButtons.count-1) {
                /// topTitleScrollView的滚动范围
                topTitleScrollView.contentSize = CGSize(width: button.right + kTopButtonLeftMargin, height: 0)
            }
            
            // 默认选中defaultPage
            if index == defaultPage {
                button.isSelected = true
                button.titleLabel?.font = UIFont.systemFont(ofSize: titleFont*selectTitleScale)
            }
        }
        
        /// 布局collectionView
        contentCollectionView.frame = CGRect(x: 0, y: topTitleViewHeight, width: self.width, height: self.height - topTitleViewHeight)
        
        let button = topTitleButtons[defaultPage]
        guard let label = topTitleButtons[currentSelectdIndex].titleLabel else {
            return
        }
        label.sizeToFit()
        /// 布局下滑线的位置
        topScrollUnderLine.width = label.width
        topScrollUnderLine.height = kTopUnderLineHeight
        topScrollUnderLine.centerX = button.centerX
        topScrollUnderLine.y = button.bottomY
        
        currentUnderLineCenterX = topScrollUnderLine.centerX
        currentUnderLineWidth = topScrollUnderLine.width
    }
}
