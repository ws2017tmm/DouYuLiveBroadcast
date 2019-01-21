//
//  DYSearchBar.swift
//  DouYuZB
//
//  Created by 李响 on 2019/1/21.
//  Copyright © 2019 StevenWu. All rights reserved.
//  搜索框

import UIKit

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
    
    /// 代理
    weak var myDelegate: DYSearchBarDelegate?
    /// 搜索图标的位置(靠左还是居中)
    private var searchIconPosition: DYSearchBarIconPosition = .left
    
    // 快速创建searchBar
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(position searchIconPosition : DYSearchBarIconPosition = .left, corner: Bool = true, rightImage imageName: String? = nil, frame: CGRect) {
        self.init(frame: frame)
        
        // 创建searchBar
//        let searchBar = DYSearchBar(frame: frame)
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
            rect.origin.x = (self.width - rect.size.width) * 0.5
        }
        return rect
    }
    
    /// 重新设置右边图片的位置
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x = rect.origin.x - 10
        return rect
    }
}
