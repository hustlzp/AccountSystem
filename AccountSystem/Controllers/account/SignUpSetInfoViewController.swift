//
//  SignUpSetInfoViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import PromiseKit
import MBProgressHUD

class SignUpSetInfoViewController: AccountBaseViewController {
    private var phone: String!
    private var nicknameField: AccountTextField!
    private var passwordField: AccountTextField!
    private var repasswordField: AccountTextField!
    
    // MARK: Lifecycle
    
    init(phone: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.phone = phone
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        nicknameField = AccountTextField(placeholder: "用户名".localized())
        stackView.addRow(nicknameField, inset: UIEdgeInsets(top: Size.accountFirstFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        passwordField = AccountTextField(placeholder: "密码".localized(), isSecure: true)
        stackView.addRow(passwordField, inset: UIEdgeInsets(top: Size.accountFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        repasswordField = AccountTextField(placeholder: "重复密码".localized(), isSecure: true)
        stackView.addRow(repasswordField, inset: UIEdgeInsets(top: Size.accountFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        let submitButton = AccountButton(title: "注册".localized(), target: self, action: #selector(submit))
        stackView.addRow(submitButton, top: 30, left: Size.accountFieldHorizonalGap, bottom: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = nicknameField.becomeFirstResponder()
        navigationItem.title = "完成注册".localized()
    }
    
    // MARK: User Interaction
    
    @objc private func submit() {
        guard let nickname = nicknameField.text?.trim(), !nickname.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "用户名不能为空".localized())
            return
        }
        
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
        
        let user = User.current() ?? User()
        user.didSetPassword = true
        user.mobilePhoneNumber = self.phone
        user.nickname = nickname
        user.password = password
        user.username = UUID().uuidString
        
        user.signUp(.promise).then { (_) -> Guarantee<Void> in
            return hud.hideForSuccess(.promise, "注册成功".localized())
        }.done({ (_) in
            self.view.endEditing(true)
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: .didSignUp, object: nil)
        }).catch({ (error) in
            hud.hideForError(error)
        })
    }
    
    // MARK: Notification Handler
    
    // MARK: View Helpers
    
    // MARK: Internal Helpers

}
