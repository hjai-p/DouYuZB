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
    class func creatItem(imageName : String, HighImageName : String, size : CGSize) ->UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: HighImageName), forState: .Highlighted)
        btn.frame = CGRect(origin: CGPointZero, size: size)
        return UIBarButtonItem(customView: btn)
    }

    // 类扩展中只能添加便利构造函数
    // 便利构造函数 1>必须以convenience开头 2> 必须明确调用一个设计的构造函数（self）
   convenience init(imageName : String, HighImageName : String = "", size : CGSize = CGSizeZero) {
    let btn = UIButton()
    btn.setImage(UIImage(named: imageName), forState: .Normal)
    
    if HighImageName != "" {
        btn.setImage(UIImage(named: HighImageName), forState: .Highlighted)

    }
    
    if size == CGSizeZero {
        btn.sizeToFit()
    } else {
        btn.frame = CGRect(origin: CGPointZero, size: size)
    }
    
    self.init(customView : btn)

    }
}
