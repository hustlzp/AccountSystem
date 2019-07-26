//
//  PhoneFieldWithSendCodeButton.swift
//  byyh
//
//  Created by hustlzp on 2019/6/24.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import AVOSCloud
import RxSwift
import RxRelay
import RxCocoa
import MBProgressHUD

class PhoneFieldWithSendCodeButton: UIView {
    private var textField: UITextField!
    private var didSend: (() -> Void)?
    private var timer: Disposable?
    private var sendCodeButton: UIButton!
    private let disposeBag = DisposeBag()
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    init(placeholder: String = "手机号", didSend: (() -> Void)? = nil) {
        super.init(frame: .zero)
        
        self.didSend = didSend
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        
        textField = UITextField()
        textField.isSecureTextEntry = false
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
        addSubview(textField)
        
        sendCodeButton = UIButton()
        sendCodeButton.setTitle("发送验证码", for: .normal)
        sendCodeButton.titleLabel?.textAlignment = .right
        sendCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        sendCodeButton.setTitleColor(UIColor.systemTint, for: .normal)
        sendCodeButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        addSubview(sendCodeButton)
        
        let border = UIView()
        border.backgroundColor = UIColor.lightGray
        addSubview(border)
        
        // 约束
        
        textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-17)
            make.left.equalToSuperview()
        }
        
        sendCodeButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(textField.snp.right)
        }
        
        border.snp.makeConstraints { (make) in
            make.height.equalTo(Size.onePixel)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: User Interaction
    
    @objc private func didTap() {
        _ = becomeFirstResponder()
    }
    
    @objc private func sendCode() {
        guard let phone = text?.trim(), phone.count == 11 else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "手机号格式不正确".localized())
            return
        }
        
        var hud: MBProgressHUD?
        if let view = UIApplication.shared.keyWindow {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
        }
        
        AVSMS.sendSmsCode(.promise, phone, applicationName: "AccountSystem", operation: "验证手机").then { (_) -> Guarantee<Void> in
            return hud?.hideForSuccess(.promise, "验证码发送成功") ?? .value(())
        }.done({ (_) in
            self.didSend?()
            
            let timer = Observable<Int>
                .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                .take(61)
                .map { (number) -> Int in
                    return 60 - number
                }.asDriver(onErrorJustReturn: 0)
            
            // 按钮标题
            timer.map({ $0 == 0 ? "发送验证码" : "\($0) 秒" })
                .drive(self.sendCodeButton.rx.title(for: .normal))
                .disposed(by: self.disposeBag)
            
            // 按钮使能
            timer.map({ $0 == 0 })
                .drive(self.sendCodeButton.rx.isEnabled)
                .disposed(by: self.disposeBag)
        }).catch { (error) in
            hud?.hideForError(error)
        }
    }

}
