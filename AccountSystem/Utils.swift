//
//  Utils.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import Foundation
import Photos
import AVOSCloud

class Utils {
    
    class func getMessageFromError(_ error: Error) -> String {
        let nsError = error as NSError
        
        if nsError.domain == "com.LeanCloud.ErrorDomain" {
            switch nsError.code {
            case 210:
                return "用户名与密码不匹配"
            default:
                return nsError.localizedFailureReason ?? error.localizedDescription
            }
        } else {
            return nsError.localizedFailureReason ?? error.localizedDescription
        }
    }
    
    class func checkAlbumAuthDenied() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .denied
    }
    
    class func showPermissionReuqestAlert(controller: UIViewController, title: String) {
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消".localized(), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "去设置".localized(), style: .default, handler: { (action) in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlbumPermissionReuqestAlert(controller: UIViewController) {
        showPermissionReuqestAlert(controller: controller, title: "请允许访问您的照片".localized())
    }
    
    class func isEmpty(_ str: String?) -> Bool {
        return str == nil || str!.isEmpty
    }
    
    class func getAuthDateAndOptionFromUMResponse(_ response: UMSocialUserInfoResponse, platform: SocialPlatform) -> (authData: [String: Any]?, option: AVUserAuthDataLoginOption?) {
        switch platform {
        case .qq:
            guard
                let openId = response.openid,
                let accessToken = response.accessToken,
                let expiration = response.expiration else { return (nil, nil) }
            
            let authData: [String: Any] = [
                "openid": openId,
                "access_token": accessToken,
                "expires_in": Int(expiration.timeIntervalSince(Date()))
            ]
            
            let option = AVUserAuthDataLoginOption()
            option.platform = LeanCloudSocialPlatform.QQ
            
            return (authData, option)
        case .wechat:
            guard
                let openId = response.openid,
                let accessToken = response.accessToken,
                let expiration = response.expiration else { return (nil, nil) }
            
            let unionId = response.unionId
            
            var authData: [String: Any] = [
                "openid": openId,
                "access_token": accessToken,
                "expires_in": Int(expiration.timeIntervalSince(Date()))
            ]
            
            if unionId != nil {
                authData["unionId"] = unionId!
            }
            
            let option = AVUserAuthDataLoginOption()
            
            option.platform = LeanCloudSocialPlatform.weiXin
            if unionId != nil {
                option.unionId = unionId!
                option.isMainAccount = true
            }
            
            return (authData, option)
        case .weibo:
            guard
                let uid = response.uid,
                let accessToken = response.accessToken,
                let expiration = response.expiration else { return (nil, nil) }
            
            let authData: [String: Any] = [
                "uid": uid,
                "access_token": accessToken,
                "expires_in": Int(expiration.timeIntervalSince(Date()))
            ]
            
            let option = AVUserAuthDataLoginOption()
            
            option.platform = LeanCloudSocialPlatform.weiBo
            
            return (authData, option)
        case .twitter:
            guard let uid = response.uid,
                let accessToken = response.accessToken else { return (nil, nil) }
            
            let expiration = response.expiration ?? (Date().addingTimeInterval(3600 * 24 * 180))
            
            let authData: [String: Any] = [
                "uid": uid,
                "access_token": accessToken,
                "expires_in": Int(expiration.timeIntervalSince(Date()))
            ]
            
            return (authData, nil)
        case .facebook:
            guard
                let uid = response.uid,
                let accessToken = response.accessToken else { return (nil, nil) }
            
            let expiration = response.expiration ?? (Date().addingTimeInterval(3600 * 24 * 180))
            
            let authData: [String: Any] = [
                "uid": uid,
                "access_token": accessToken,
                "expires_in": Int(expiration.timeIntervalSince(Date()))
            ]
            
            return (authData, nil)
        case .apple:
            return (nil, nil)
        }
    }
    
}
