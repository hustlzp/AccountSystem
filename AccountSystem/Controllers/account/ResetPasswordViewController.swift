//
//  ResetPasswordViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import MBProgressHUD
import PromiseKit
import AVOSCloud

class ResetPasswordViewController: AccountBaseViewController {
    private var phone: String!
    private var newPasswordField: AccountTextField!
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
        
        newPasswordField = AccountTextField(placeholder: "新密码".localized(), isSecure: true)
        stackView.addRow(newPasswordField, inset: UIEdgeInsets(top: Size.accountFirstFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        repasswordField = AccountTextField(placeholder: "重复新密码".localized(), isSecure: true)
        stackView.addRow(repasswordField, inset: UIEdgeInsets(top: Size.accountFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        let sumitButton = AccountButton(title: "重置".localized(), target: self, action: #selector(submit))
        stackView.addRow(sumitButton, top: 30, left: Size.accountFieldHorizonalGap, bottom: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = newPasswordField.becomeFirstResponder()
    }
    
    // MARK: User Interaction
    
    @objc private func submit() {
        guard let newPassword = newPasswordField.text?.trim(), !newPassword.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "新密码不能为空".localized())
            return
        }
        
        guard let repassword = repasswordField.text?.trim(), !repassword.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "重复新密码不能为空".localized())
            return
        }
        
        guard repassword == newPassword else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "两次密码输入不一致".localized())
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        User.resetPassword(phone: phone, password: newPassword).then { _ in
            hud.hideForSuccess(.promise, "密码重置成功，请登录".localized())
        }.done { _ in
            guard let signInController = self.navigationController?.viewControllers.filter({ $0 is SignInViewController }).first else {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            
            self.navigationController?.popToViewController(signInController, animated: true)
        }.catch { (error) in
            hud.hideForError(error)
        }
    }
    
    // MARK: Notification Handler
    
    // MARK: View Helpers
    
    // MARK: Internal Helpers

}
