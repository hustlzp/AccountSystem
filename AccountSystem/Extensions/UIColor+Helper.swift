//
//  UIColor+Helper.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit


extension UIColor {
    static var systemTint: UIColor {
        return UIColor(hex: 0x007AFF)
    }
    
    convenience init(hex: Int64) {
        self.init(red: (CGFloat)((hex >> 16) & 0xFF) / 255.0, green: (CGFloat)((hex >> 8) & 0xFF) / 255.0, blue: (CGFloat)(hex & 0xFF) / 255.0, alpha: 1)
    }
}
