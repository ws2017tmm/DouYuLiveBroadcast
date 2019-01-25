//
//  DYSearchBar.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/21.
//  Copyright © 2019 StevenWu. All rights reserved.
//  搜索框

import UIKit

let kSpaceBetweenIconAndPlaceholder: CGFloat = 5.0

enum DYSearchBarIconPosition {
    case left
    case center
}

// MARK: - 定义协议
protocol DYSearchBarDelegate: UITextFieldDelegate {
    /// 右边图标的点击
    func searchBar(_ searchBar: DYSearchBar, didSelected rightView: UIView?)
    /// 搜索框点击
    func searchBarDidBeginEditing(_ searchBar: DYSearchBar)
}

// MARK: - 快速创建DYSearchBar
class DYSearchBar: UITextField {

    private struct RuntimeKey {
        static let placeholderColor = UnsafeRawPointer(bitPattern: "placeholderColor".hashValue)
        static let placeholderSize = UnsafeRawPointer(bitPattern: "placeholderSize".hashValue)
    }
    
    /// 代理
    weak var myDelegate: DYSearchBarDelegate?
    /// 搜索图标的位置(靠左还是居中)
    private var searchIconPosition: DYSearchBarIconPosition = .left
    /// 光标的颜色(默认蓝色)
    var cursorColor: UIColor = .green {
        didSet {
            self.tintColor = cursorColor
        }
    }
    
    /// 定时器
    private var timer: Timer?
    
    /// 默认切换占位文字的时间(3秒)
    var defaultChangePlaceholderTime: TimeInterval = 3.0 {
        didSet {
            if timer == nil { return }
            removeTimer()
            createTimer()
        }
    }
    
    /// 占位文字数组
    var placeholderList: [String]? {
        didSet {
            if placeholderList == nil { return }
            createTimer()
        }
    }
    
    
    /// 占位文字的大小(默认13) placeholderSize
    var placeholderSize: CGFloat {
        set {
            guard let placeholderSize = RuntimeKey.placeholderSize else {
                return
            }
            objc_setAssociatedObject(self, placeholderSize, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            guard let placeholderSize = RuntimeKey.placeholderSize else {
                return 13.0
            }
            let size = objc_getAssociatedObject(self, placeholderSize) as? CGFloat
            return size ?? 13.0
        }
    }
    /// 占位文字的颜色(默认灰色)
    var placeholderColor: UIColor {
        set {
            guard let placeholderColor = RuntimeKey.placeholderColor else {
                return
            }
            objc_setAssociatedObject(self, placeholderColor, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            guard let placeholderColor = RuntimeKey.placeholderColor else {
                return UIColor(rgb: 165.0)
            }
            let color = objc_getAssociatedObject(self, placeholderColor) as? UIColor
            return color ?? UIColor(rgb: 165.0)
        }
    }
    
    // 快速创建searchBar
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 快速创建searchBar
    ///
    /// - Parameters:
    ///   - searchIconPosition: 🔍图标的位置(只支持靠左和居中)
    ///   - corner: 是否是圆角(默认是圆角)
    ///   - imageName: 右边是否有图标(默认没有)
    ///   - frame: 搜索框的frame
    convenience init(position searchIconPosition : DYSearchBarIconPosition = .left, corner: Bool = true, rightImage imageName: String? = nil, frame: CGRect) {
        self.init(frame: frame)
        
        // 创建searchBar
//        self.placeholder = "uzi1309r209ru3g"
        self.delegate = self
        self.backgroundColor = UIColor.white
        self.searchIconPosition = searchIconPosition
        
        // 是否圆角
        if corner {
            self.layer.cornerRadius = self.height * 0.5;
            self.layer.masksToBounds = true
        }
        
        // 左边搜索图标
        let leftImage = UIImage(named: "cm_nav_search_inner")
        let leftView = UIImageView(image: leftImage)
        // 要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
        leftView.contentMode = .center
        leftView.sizeToFit()
        self.leftView = leftView
        self.leftViewMode = .always
        
        if imageName != nil {
            // 右边搜索图标
            let rightImage = UIImage(named: imageName!)
            let rightView = UIImageView(image: rightImage)
            rightView.isUserInteractionEnabled = true
            let tapGues = UITapGestureRecognizer(target: self, action: #selector(scan))
            rightView .addGestureRecognizer(tapGues)
            // 要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
            rightView.contentMode = .center
            rightView.sizeToFit()
            self.rightView = rightView
            self.rightViewMode = .always
        }
    }
    
}

// MARK: - 定时器
extension DYSearchBar {
    private func createTimer() {
        var index = 0
        timer = Timer(timeInterval: defaultChangePlaceholderTime, repeats: true, block: { _ in
            if index >= (self.placeholderList?.count)! {
                index = 0
            }
            let placeholder = self.placeholderList![index]
            self.placeholder = placeholder
            index += 1
        })
        RunLoop.current.add(timer!, forMode: .common)
        timer?.fire()
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - 点击事件处理
extension DYSearchBar: UITextFieldDelegate {
    /// 点击右边的图片
    @objc func scan(tapGues: UITapGestureRecognizer) {
        myDelegate?.searchBar(self, didSelected: self.rightView)
    }
    /// 开始编辑
    func textFieldDidBeginEditing(_ textField: UITextField) {
        myDelegate?.searchBarDidBeginEditing(self)
    }
}

// MARK: - 重写父类方法,布局
extension DYSearchBar {
    /// 重新设置左边图片的位置
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        if searchIconPosition == .left {
            rect.origin.x = 10
        } else {
            // 计算placeholder的文字长度
            guard let placeholder = placeholder else {
                rect.origin.x = (self.width - rect.size.width) * 0.5
                return rect
            }
            let placeholderWidth = NSString(string: placeholder).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: rect.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : placeholderSize], context: nil).size.width
            
            rect.origin.x = (self.width - rect.size.width - placeholderWidth) * 0.5 - kSpaceBetweenIconAndPlaceholder
            
        }
        return rect
    }
    
    /// 重新设置右边图片的位置
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x = rect.origin.x - 10
        return rect
    }
    
    /// 占位文字的位置
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: bounds)
        rect.origin.x = rect.origin.x + kSpaceBetweenIconAndPlaceholder
        return rect
    }
    
}


extension DYSearchBar {
    static let ws_initialize: Void = {
        DispatchQueue.once(UUID().uuidString) {
            swizzleMethod(DYSearchBar.self,
                          originalSelector: #selector(setter: DYSearchBar.placeholder),
                          swizzleSelector: #selector(DYSearchBar.ws_placeholder))
        }
    }()
    
    @objc private func ws_placeholder() {
        ws_placeholder()
        
        let label = self.value(forKeyPath: "placeholderLabel")
        guard let placeholderLabel = label as? UILabel  else {
            return
        }
        placeholderLabel.textColor = self.placeholderColor
        placeholderLabel.font = UIFont.systemFont(ofSize: self.placeholderSize)
    }
}


