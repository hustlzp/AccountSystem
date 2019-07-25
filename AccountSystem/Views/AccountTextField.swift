//
//  AccountTextField.swift
//  ukiyoe
//
//  Created by hustlzp on 2019/6/28.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit

class AccountTextField: UIView {
    private var textField: UITextField!
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    init(placeholder: String?, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        super.init(frame: .zero)
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        
        textField = UITextField()
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: UIColor.lightGray])
        addSubview(textField)
        
        let border = UIView()
        border.backgroundColor = UIColor.lightGray
        addSubview(border)
        
        // 约束
        
        textField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 17, left: 0, bottom: 17, right: 0))
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

}
