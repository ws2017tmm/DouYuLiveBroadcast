//
//  DYTabBar.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/17.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

class DYTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = UIColor.orange
        barTintColor = UIColor.white
        
        guard let btnClass = NSClassFromString("UITabBarButton") else { return }
        
        for tabBarButton in self.subviews {
            
            if tabBarButton.isKind(of: btnClass) {
                
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(self.subviews)
        
    }
    
    
    
    

}
