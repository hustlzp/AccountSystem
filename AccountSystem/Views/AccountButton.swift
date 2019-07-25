//
//  AccountButton.swift
//  ukiyoe
//
//  Created by hustlzp on 2019/6/28.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit

class AccountButton: UIButton {
    init(title: String, target: Any, action: Selector, horizonalGap: CGFloat = Size.horizonalGap) {
        super.init(frame: .zero)
        
        layer.borderWidth = 1 + Size.onePixel
        layer.borderColor = UIColor.systemTint.cgColor
        layer.cornerRadius = 4
        setTitle(title, for: .normal)
        setTitleColor(UIColor.systemTint, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        addTarget(target, action: action, for: .touchUpInside)
        
        snp.makeConstraints { (make) in
            make.height.equalTo(46)
            make.width.equalTo(self.intrinsicContentSize.width + 2 * 20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
