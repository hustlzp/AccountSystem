//
//  UMSocialManager+Helper.swift
//  oracle
//
//  Created by hustlzp on 2019/7/24.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import Foundation
import PromiseKit

extension UMSocialManager {
    func getUserInfo(_: PMKNamespacer, platformType: UMSocialPlatformType, currentViewController: Any) -> Promise<UMSocialUserInfoResponse> {
        return Promise(resolver: { (seal) in
            getUserInfo(with: platformType, currentViewController: currentViewController, completion: { (result, error) in
                seal.resolve(result as? UMSocialUserInfoResponse, error)
            })
        })
    }
}
