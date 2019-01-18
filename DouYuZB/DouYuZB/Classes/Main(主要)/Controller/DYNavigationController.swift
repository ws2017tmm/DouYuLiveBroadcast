//
//  DYNavigationController.swift
//  DouYuZB
//
//  Created by StevenWu on 2019/1/17.
//  Copyright © 2019 StevenWu. All rights reserved.
//

import UIKit

class DYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage.image(UIColor(r: 253, g: 129, b: 82)), for: .default)
        
        
    }
    

}


