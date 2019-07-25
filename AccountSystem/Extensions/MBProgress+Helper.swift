//
//  MBProgress+Helper.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import MBProgressHUD
import ionicons
import PromiseKit

extension MBProgressHUD {
    
    // MARK: Success
    
    func hideForSuccess(_ text: String? = nil, duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        label.text = text
        mode = .customView
        customView = UIImageView(image: IonIcons.image(withIcon: ion_checkmark, size: 37, color: UIColor(hex: 0x444546)))
        
        after(seconds: duration).done { (_) in
            self.hide(animated: true)
            completion?()
        }
    }
    
    func hideForSuccess(_: PMKNamespacer, _ text: String? = nil, duration: TimeInterval = 1) -> Guarantee<Void> {
        return Guarantee<Void>(resolver: { (resolver) in
            self.hideForSuccess(text, duration: duration, completion: {
                resolver(())
            })
        })
    }
    
    class func showForSuccess(view: UIView, text: String? = nil, duration: Double = 1,  completion: (() -> Void)? = nil) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.label.text = text
        hud.mode = .customView
        hud.customView = UIImageView(image: IonIcons.image(withIcon: ion_checkmark, size: 37, color: UIColor(hex: 0x444546)))
        
        after(seconds: duration).done { (_) in
            hud.hide(animated: true)
            completion?()
        }
    }
    
    // MARK: Info
    
    func hideForInfo(_ text: String?, completion: (() -> Void)? = nil) {
        label.text = text
        mode = .text
        
        after(seconds: 1).done { (_) in
            self.hide(animated: true)
            completion?()
        }
    }
    
    class func showForInfo(_ view: UIView, text: String, duration: TimeInterval = 1,  completion: (() -> Void)? = nil) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.label.text = text
        hud.mode = .text
        
        after(seconds: duration).done { (_) in
            hud.hide(animated: true)
            completion?()
        }
    }
    
    class func showForInfo(_: PMKNamespacer, _ view: UIView, text: String? = nil, duration: TimeInterval = 1) -> Guarantee<Void> {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.label.text = text
        hud.mode = .text
        
        return after(seconds: duration).done({ (_) in
            hud.hide(animated: true)
        })
    }
    
    // MARK: Error
    
    func hideForError(_ error: Error, duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        let message = Utils.getMessageFromError(error)
        
        label.text = message
        mode = .text
        
        after(seconds: duration).done { (_) in
            self.hide(animated: true)
            completion?()
        }
    }
    
    func hideForError(_: PMKNamespacer, _ error: Error, duration: TimeInterval = 1, completion: (() -> Void)? = nil) -> Guarantee<Void> {
        return Guarantee<Void>(resolver: { (resolver) in
            self.hideForError(error, duration: duration, completion: {
                resolver(())
            })
        })
    }
    
    class func showForError(_ view: UIView, error: Error, duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        let message = Utils.getMessageFromError(error)
        
        hud.label.text = message
        hud.mode = .text
        
        after(seconds: duration).done { (_) in
            hud.hide(animated: true)
            completion?()
        }
    }
    
    class func showForError(_: PMKNamespacer, _ view: UIView, error: Error, duration: TimeInterval = 1) -> Guarantee<Void> {
        
        return Guarantee(resolver: { (resolver) in
            self.showForError(view, error: error, duration: duration, completion: {
                resolver(())
            })
        })
    }
    
}
