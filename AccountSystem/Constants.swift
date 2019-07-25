//
//  Constants.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import Foundation
import AVOSCloud

struct Size {
    static var statusBarHeight: CGFloat {
        return safeAreaTopGap > 0 ? safeAreaTopGap : 20
    }
    static var navigationBarWithoutStatusHeight: CGFloat {
        if Device.isPad, #available(iOS 12.0, *) {
            return 50
        } else {
            return 44
        }
    }
    static let navigationBarHeight: CGFloat = navigationBarWithoutStatusHeight + statusBarHeight
    static let tabBarHeight: CGFloat = 49 + 1 / UIScreen.main.scale
    static var safeAreaTopGap: CGFloat {
        let window = UIApplication.shared.keyWindow
        
        return window?.safeAreaInsets.top ?? 0
    }
    static var safeAreaBottomGap: CGFloat {
        let window = UIApplication.shared.keyWindow
        
        return window?.safeAreaInsets.bottom ?? 0
    }
    static var screenWidth: CGFloat {
        return UIApplication.shared.keyWindow?.bounds.width ?? UIScreen.main.bounds.width
    }
    static var screenHeight: CGFloat {
        return UIApplication.shared.keyWindow?.bounds.height ?? UIScreen.main.bounds.height
    }
    static let screenMaxLength = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
    static let screenMinLength = min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
    static var horizonalGap: CGFloat {
        if Device.isPhone {
            if Size.screenWidth <= 320 {
                return 15
            } else {
                return 20
            }
        } else {
            return 50
        }
    }
    
    static let onePixel = 1 / UIScreen.main.scale
    
    static let accountFirstFieldTopGap: CGFloat = 55
    static let accountFieldTopGap: CGFloat = 5
    static var accountFieldHorizonalGap: CGFloat {
        return Size.horizonalGap + 5
    }
}

struct Device {
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

extension Notification.Name {
    static let didSignUp = Notification.Name("didSignUp")
    static let didSignIn = Notification.Name("didSignIn")
    static let didSignOut = Notification.Name("disSignOut")
    static let didUpdateUserInfo = Notification.Name("didUpdateUserInfo")
}

enum SocialPlatform: CaseIterable {
    case qq
    case wechat
    case weibo
    case twitter
    case facebook
    
    var platformIdForLeanCloud: String {
        switch self {
        case .qq:
            return LeanCloudSocialPlatform.QQ.rawValue
        case .wechat:
            return LeanCloudSocialPlatform.weiXin.rawValue
        case .weibo:
            return LeanCloudSocialPlatform.weiBo.rawValue
        case .twitter:
            return "twitter"
        case .facebook:
            return "facebook"
        }
    }
    
    var platformTypeForUM: UMSocialPlatformType {
        switch self {
        case .qq:
            return .QQ
        case .wechat:
            return .wechatTimeLine
        case .weibo:
            return .sina
        case .twitter:
            return .twitter
        case .facebook:
            return .facebook
        }
    }
    
    var name: String {
        switch self {
        case .qq:
            return "QQ"
        case .wechat:
            return "微信"
        case .weibo:
            return "微博"
        case .twitter:
            return "Twitter"
        case .facebook:
            return "Facebook"
        }
    }
    
    var didSetKeyPath: ReferenceWritableKeyPath<User, Bool> {
        switch self {
        case .qq:
            return \User.didBindQQ
        case .wechat:
            return \User.didBindWechat
        case .weibo:
            return \User.didBindWeibo
        case .twitter:
            return \User.didBindTwitter
        case .facebook:
            return \User.didBindFacebook
        }
    }
    
    var iconName: String {
        switch self {
        case .qq:
            return "account/qq"
        case .wechat:
            return "account/wechat"
        case .weibo:
            return "account/weibo"
        case .twitter:
            return "account/twitter"
        case .facebook:
            return "account/facebook"
        }
    }
}
