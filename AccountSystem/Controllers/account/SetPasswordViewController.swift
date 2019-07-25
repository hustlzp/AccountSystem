//
//  SetPasswordViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import MBProgressHUD
import PromiseKit

class SetPasswordViewController: AccountBaseViewController {
    private var passwordField: AccountTextField!
    private var repasswordField: AccountTextField!
    
    // MARK: Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        passwordField = AccountTextField(placeholder: "密码", isSecure: true)
        stackView.addRow(passwordField, inset: UIEdgeInsets(top: Size.accountFirstFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        repasswordField = AccountTextField(placeholder: "重复密码", isSecure: true)
        stackView.addRow(repasswordField, inset: UIEdgeInsets(top: Size.accountFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        let submitButton = AccountButton(title: "设置", target: self, action: #selector(submit))
        stackView.addRow(submitButton, top: 30, left: Size.accountFieldHorizonalGap, bottom: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = passwordField.becomeFirstResponder()
        navigationItem.title = "设置密码".localized()
    }
    
    // MARK: User Interaction
    
    @objc private func submit() {
        guard let user = User.current() else { return }
        guard let password = passwordField.text?.trim(), !password.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "密码不能为空".localized())
            return
        }
        
        guard let repassword = repasswordField.text?.trim(), !repassword.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "重复密码不能为空".localized())
            return
        }
        
        guard repassword == password else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "两次密码输入不一致".localized())
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        user.password = password
        user.didSetPassword = true
        user.save(.promise).then { _ in
            hud.hideForSuccess(.promise)
        }.done { (_) in
            guard let accountSettingsController = self.navigationController?.viewControllers.filter({ $0 is AccountSettingsViewController }).first else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            self.navigationController?.popToViewController(accountSettingsController, animated: true)
        }.ensure {
            NotificationCenter.default.post(name: .didUpdateUserInfo, object: nil)
        }.catch { (error) in
            hud.hideForError(error)
        }
    }
    
    // MARK: Notification Handler
    
    // MARK: View Helpers
    
    // MARK: Internal Helpers

}
