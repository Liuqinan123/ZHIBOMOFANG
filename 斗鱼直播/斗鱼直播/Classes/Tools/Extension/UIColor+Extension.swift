//
//  UIColor+Extension.swift
//  斗鱼直播
//
//  Created by Apple on 2016/10/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r:Int,g:Int,b:Int) {
      self.init(colorLiteralRed: Float(r) / 255.0, green: Float(g)/255.0, blue: Float(b)/255.0, alpha: 1)
    }
}
