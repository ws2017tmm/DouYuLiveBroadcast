//
//  UIBarButtonItem+FixSpace.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/21.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    static func swizzleMethod(_ cls: AnyClass, originalSelector: Selector, swizzleSelector: Selector){
        
        let originalMethod = class_getInstanceMethod(cls, originalSelector)!
        let swizzledMethod = class_getInstanceMethod(cls, swizzleSelector)!
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

extension UIApplication {
    private static let classSwizzedMethod: Void = {
        UINavigationController.ws_initialize
        DYSearchBar.ws_initialize
        if #available(iOS 11.0, *) {
            UINavigationBar.ws_initialize
        }
    }()
    
    open override var next: UIResponder? {
        UIApplication.classSwizzedMethod
        return super.next
    }
}

public var ws_defultFixSpace: CGFloat = 0
public var ws_disableFixSpace: Bool = false

extension UINavigationController {
    
    private struct AssociatedKeys {
        static var tempDisableFixSpace = "tempDisableFixSpace"
        static var tempBehavor = "tempBehavor"
    }
    
    static let ws_initialize: Void = {
        DispatchQueue.once(UUID().uuidString) {
            
            swizzleMethod(UINavigationController.self,
                          originalSelector: #selector(UINavigationController.viewDidLoad),
                          swizzleSelector: #selector(UINavigationController.ws_viewDidLoad))
            
            swizzleMethod(UINavigationController.self,
                          originalSelector: #selector(UINavigationController.viewWillAppear(_:)),
                          swizzleSelector: #selector(UINavigationController.ws_viewWillAppear(_:)))
            
            swizzleMethod(UINavigationController.self,
                          originalSelector: #selector(UINavigationController.viewWillDisappear(_:)),
                          swizzleSelector: #selector(UINavigationController.ws_viewWillDisappear(_:)))
            
        }
    }()
    
    private var tempDisableFixSpace: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tempDisableFixSpace) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tempDisableFixSpace, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @available(iOS 11.0, *)
    private var tempBehavor: UIScrollView.ContentInsetAdjustmentBehavior {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tempBehavor) as? UIScrollView.ContentInsetAdjustmentBehavior ?? .automatic
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tempBehavor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func ws_viewDidLoad() {
        disableFixSpace(true, with: true)
        ws_viewDidLoad()
    }
    
    @objc private func ws_viewWillAppear(_ animated: Bool) {
        disableFixSpace(true, with: false)
        ws_viewWillAppear(animated)
    }
    
    @objc private func ws_viewWillDisappear(_ animated: Bool) {
        disableFixSpace(false, with: true)
        ws_viewWillDisappear(animated)
    }
    
    private func disableFixSpace(_ disable: Bool, with temp: Bool) {
        if type(of: self) == UIImagePickerController.self {
            if disable == true {
                if temp { tempDisableFixSpace = ws_disableFixSpace }
                ws_disableFixSpace = true
                if #available(iOS 11.0, *) {
                    tempBehavor = UIScrollView.appearance().contentInsetAdjustmentBehavior
                    UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
                }
            } else {
                ws_disableFixSpace = tempDisableFixSpace
                if #available(iOS 11.0, *) {
                    UIScrollView.appearance().contentInsetAdjustmentBehavior = tempBehavor
                }
            }
        }
    }
}

@available(iOS 11.0, *)
extension UINavigationBar {
    
    static let ws_initialize: Void = {
        DispatchQueue.once(UUID().uuidString) {
            swizzleMethod(UINavigationBar.self,
                          originalSelector: #selector(UINavigationBar.layoutSubviews),
                          swizzleSelector: #selector(UINavigationBar.ws_layoutSubviews))
            
        }
    }()
    
    @objc func ws_layoutSubviews() {
        ws_layoutSubviews()
        
        if ws_disableFixSpace == false {
            layoutMargins = .zero
            let space = ws_defultFixSpace
            for view in subviews {
                if NSStringFromClass(view.classForCoder).contains("ContentView") {
                    view.layoutMargins = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
                }
            }
        }
    }
}

extension UINavigationItem {
    
    private enum BarButtonItem: String {
        case left = "_leftBarButtonItem"
        case right = "_rightBarButtonItem"
    }
    
    open override func setValue(_ value: Any?, forKey key: String) {
        
        if #available(iOS 11.0, *) {
            super.setValue(value, forKey: key)
        } else {
            if ws_disableFixSpace == false && (key == BarButtonItem.left.rawValue || key == BarButtonItem.right.rawValue) {
                guard let item = value as? UIBarButtonItem else {
                    super.setValue(value, forKey: key)
                    return
                }
                let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                space.width = ws_defultFixSpace - 16
                
                if key == BarButtonItem.left.rawValue {
                    leftBarButtonItems = [space, item]
                } else {
                    rightBarButtonItems = [space, item]
                }
            } else {
                super.setValue(value, forKey: key)
            }
        }
    }
}


