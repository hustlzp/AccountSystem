//
//  UIViewController+Helper.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import PromiseKit

extension UIViewController {
    func showConfirmController(style: UIAlertController.Style, title: String, message: String? = nil, confirmText: String, confirmStyle: UIAlertAction.Style, showCancelButton: Bool = true, sourceView: UIView? = nil, barButtonItem: UIBarButtonItem? = nil) -> Promise<Void> {
        return Promise<Void>(resolver: { (resolver) in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            let action = UIAlertAction(title: confirmText, style: confirmStyle) { (_) in
                resolver.fulfill(())
            }
            alertController.addAction(action)
            
            if showCancelButton {
                let cancelAction = UIAlertAction(title: "取消".localized(), style: .cancel, handler: { (_) in
                    resolver.reject(PMKError.cancelled)
                })
                alertController.addAction(cancelAction)
            }
            
            if let popoverPresentationController = alertController.popoverPresentationController {
                if let sourceView = sourceView {
                    popoverPresentationController.sourceView = sourceView
                    popoverPresentationController.sourceRect = sourceView.bounds
                } else if let item = barButtonItem {
                    popoverPresentationController.barButtonItem = item
                }
            }
            
            present(alertController, animated: true, completion: nil)
        })
    }
}
