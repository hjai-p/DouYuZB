//
//  UIBarButtonItem-Extension.swift
//  DouYuZB
//
//  Created by PH on 17/2/16.
//  Copyright © 2017年 HJ. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    // class表示是类方法
    class func creatItem(_ imageName : String, HighImageName : String, size : CGSize) ->UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        btn.setImage(UIImage(named: HighImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem(customView: btn)
    }

    // 类扩展中只能添加便利构造函数
    // 便利构造函数 1>必须以convenience开头 2> 必须明确调用一个设计的构造函数（self）
   convenience init(imageName : String, HighImageName : String = "", size : CGSize = CGSize.zero) {
    let btn = UIButton()
    btn.setImage(UIImage(named: imageName), for: UIControlState())
    
    if HighImageName != "" {
        btn.setImage(UIImage(named: HighImageName), for: .highlighted)

    }
    
    if size == CGSize.zero {
        btn.sizeToFit()
    } else {
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
    }
    
    self.init(customView : btn)

    }
}
