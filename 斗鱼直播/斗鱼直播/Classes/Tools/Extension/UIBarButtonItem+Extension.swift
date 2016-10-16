//
//  UIBarButtonItem+Extension.swift
//  斗鱼直播
//
//  Created by Apple on 2016/10/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    convenience init(imageName:String, highlitedImage:String = "",size:CGSize = CGSize(width: 0, height: 0)) {
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        if highlitedImage != "" {
            btn.setImage(UIImage(named:imageName), for: .highlighted)
        }
        if size == CGSize(width:0,height:0) {
            btn.sizeToFit()
        }else {
            btn.frame = CGRect(x: 0, y: 0, width:size.width, height: size.height)
        }
        self.init(customView:btn)
    }


}
