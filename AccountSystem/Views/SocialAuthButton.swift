//
//  SocialAuthButton.swift
//  byyh
//
//  Created by hustlzp on 2019/6/26.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit

class SocialAuthButton: UIButton {
    init(platformType: SocialPlatform, target: Any, action: Selector) {
        super.init(frame: .zero)
        
        contentEdgeInsets = UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 12)
        addTarget(target, action: action, for: .touchUpInside)
        
        switch platformType {
        case .qq:
            setImage(UIImage(named: "account/qq"), for: .normal)
        case .wechat:
            setImage(UIImage(named: "account/wechat"), for: .normal)
        case .weibo:
            setImage(UIImage(named: "account/weibo"), for: .normal)
        case .twitter:
            setImage(UIImage(named: "account/twitter"), for: .normal)
        case .facebook:
            setImage(UIImage(named: "account/facebook"), for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
