//
//  ChangePasswordViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import MBProgressHUD
import PromiseKit

class ChangePasswordViewController: AccountBaseViewController {
    private var oldPasswordField: AccountTextField!
    private var newPasswordField: AccountTextField!
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
        
        oldPasswordField = AccountTextField(placeholder: "原密码".localized(), isSecure: true)
        stackView.addRow(oldPasswordField, inset: UIEdgeInsets(top: Size.accountFirstFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        newPasswordField = AccountTextField(placeholder: "新密码".localized(), isSecure: true)
        stackView.addRow(newPasswordField, inset: UIEdgeInsets(top: Size.accountFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        repasswordField = AccountTextField(placeholder: "重复新密码".localized(), isSecure: true)
        stackView.addRow(repasswordField, inset: UIEdgeInsets(top: Size.accountFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.horizonalGap))
        
        let sumitButton = AccountButton(title: "修改".localized(), target: self, action: #selector(submit))
        stackView.addRow(sumitButton, top: 30, left: Size.accountFieldHorizonalGap, bottom: 30)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = oldPasswordField.becomeFirstResponder()
        navigationItem.title = "修改密码".localized()
    }
    
    // MARK: User Interaction
    
    @objc private func submit() {
        guard let user = User.current() else { return }
        
        guard let password = oldPasswordField.text?.trim(), !password.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "原密码不能为空".localized())
            return
        }
        
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
        
        view.endEditing(true)
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        user.updatePassword(.promise, password, newPassword).then { _ in
            hud.hideForSuccess(.promise, "密码修改成功")
        }.done { _ in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: .didUpdateUserInfo, object: nil)
        }.catch { (error) in
            hud.hideForError(error)
        }
    }
    
    // MARK: Notification Handler
    
    // MARK: View Helpers
    
    // MARK: Internal Helpers
    
}
