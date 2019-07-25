//
//  ChangeNicknameViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import MBProgressHUD
import PromiseKit

class ChangeNicknameViewController: AccountBaseViewController {
    private var nicknameField: AccountTextField!
    
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
        
        nicknameField = AccountTextField(placeholder: "用户名".localized(), isSecure: false)
        nicknameField.text = User.current()?.nickname
        stackView.addRow(nicknameField, inset: UIEdgeInsets(top: Size.accountFirstFieldTopGap, left: Size.accountFieldHorizonalGap, bottom: 0, right: Size.accountFieldHorizonalGap))
        
        let submitButton = AccountButton(title: "保存".localized(), target: self, action: #selector(submit))
        stackView.addRow(submitButton, top: 30, left: Size.accountFieldHorizonalGap, bottom: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "修改用户名".localized()
        _ = nicknameField.becomeFirstResponder()
    }
    
    // MARK: User Interaction
    
    @objc private func submit() {
        guard let user = User.current() else { return }
        guard let nickname = nicknameField.text?.trim(), !nickname.isEmpty else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "用户名不能为空".localized())
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        view.endEditing(true)
        
        user.nickname = nickname
        user.save(.promise).then({ (_) -> Guarantee<Void> in
            return hud.hideForSuccess(.promise)
        }).done({
            NotificationCenter.default.post(name: .didUpdateUserInfo, object: nil)
            self.navigationController?.popViewController(animated: true)
        }).catch({ (error) in
            hud.hideForInfo("保存失败，请检查网络连接".localized())
        })
    }
    
    // MARK: Notification Handler
    
    // MARK: View Helpers
    
    // MARK: Internal Helpers
}
