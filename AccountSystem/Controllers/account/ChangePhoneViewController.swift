//
//  ChangePhoneViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import AVOSCloud
import MBProgressHUD
import PromiseKit

class ChangePhoneViewController: AccountBaseViewController {
    private var phoneField: PhoneFieldWithSendCodeButton!
    private var codeField: AccountTextField!
    
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
        
        phoneField = PhoneFieldWithSendCodeButton(placeholder: "新手机号", didSend: { [weak self] in
            _ = self?.codeField.becomeFirstResponder()
        })
        stackView.addRow(phoneField, inset: UIEdgeInsets(top: Size.accountFirstFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        codeField = AccountTextField(placeholder: "验证码".localized(), keyboardType: .numberPad, isSecure: false)
        stackView.addRow(codeField, inset: UIEdgeInsets(top: Size.accountFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        let submitButton = AccountButton(title: "保存".localized(), target: self, action: #selector(submit))
        stackView.addRow(submitButton, top: 30, left: Size.accountFieldHorizonalGap, bottom: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = phoneField.becomeFirstResponder()
        navigationItem.title = "修改手机号".localized()
    }
    
    // MARK: User Interaction
    
    @objc private func submit() {
        guard let user = User.current() else { return }
        
        guard let phone = phoneField.text?.trim(), !phone.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "手机号不能为空".localized())
            return
        }
        
        guard phone != user.mobilePhoneNumber else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "新手机号与原手机号一致".localized())
            return
        }
        
        guard let code = codeField.text?.trim(), !code.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "验证码不能为空".localized())
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        User.checkPhoneExist(phone).then { (exist) -> Promise<Void> in
            if exist {
                throw MyError.custom(errorDescription: "手机号已被注册")
            }
            
            return AVSMS.verifySmsCode(.promise, code, mobilePhoneNumber: phone)
        }.then { (_) -> Promise<User> in
            user.mobilePhoneNumber = phone
            
            return user.save(.promise)
        }.then({ (_) -> Guarantee<Void> in
            return hud.hideForSuccess(.promise)
        }).done({ _ in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: .didUpdateUserInfo, object: nil)
        }).catch { (error) in
            hud.hideForError(error)
        }
    }
    
    // MARK: Notification Handler
    
    // MARK: View Helpers
    
    // MARK: Internal Helpers

}
