//
//  User.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import AVOSCloud

class User: AVUser {
    @NSManaged var avatar: AVFile?
    @NSManaged var nickname: String?
    @NSManaged var didSetPassword: Bool
    @NSManaged var didBindWechat: Bool
    @NSManaged var didBindWeibo: Bool
    @NSManaged var didBindQQ: Bool
    @NSManaged var didBindFacebook: Bool
    @NSManaged var didBindTwitter: Bool
    @NSManaged var didBindApple: Bool

    // MARK: Account

    class func checkPhoneExist(_ phone: String) -> Promise<Bool> {
        return AVCloud.callFunction(.promise, name: "checkPhoneExist", parameters: ["phone": phone])
    }
    
    class func resetPassword(phone: String, password: String) -> Promise<Void> {
        return AVCloud.callFunction(.promise, name: "resetPassword", parameters: ["phone": phone, "password": password]).map({ _ in () })
    }
    
}
