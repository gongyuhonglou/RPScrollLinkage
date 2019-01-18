//
//  UIColor+.swift
//  RPScrollLinkage
//
//  Created by rpweng on 2019/1/17.
//  Copyright © 2019 rpweng. All rights reserved.
//
// UIColor扩展

import UIKit

extension UIColor {
    
    //使用rgb方式生成自定义颜色
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    //使用rgba方式生成自定义颜色
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}
