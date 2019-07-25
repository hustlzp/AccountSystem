//
//  AccountBaseViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit

class AccountBaseViewController: StackViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    // MARK: User Interaction
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

}
