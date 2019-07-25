//
//  MeViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var userInfoView: UserInfoView!
    private var isAnonymous: Bool {
        return User.current()?.isAnonymous() ?? true
    }

    // MARK: Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: .didSignIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSignUp), name: .didSignUp, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSignOut), name: .didSignOut, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateUserInfo), name: .didUpdateUserInfo, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        view.addSubview(tableView)
        
        userInfoView = UserInfoView()
        
        // 约束
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我"
        
        _ = User.current()?.fetch(.promise).done({ (_) in
            self.userInfoView?.update()
        })
    }
    
    // MARK: User Interaction
    
    @objc private func didSignIn() {
        userInfoView?.update()
    }
    
    @objc private func didSignUp() {
        userInfoView?.update()
    }
    
    @objc private func didSignOut() {
        userInfoView?.update()
    }
    
    @objc private func didUpdateUserInfo() {
        userInfoView?.update()
    }
    
    // MARK: Notification Handler
    
    // MARK: UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            configUserInfoCell(cell)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            if isAnonymous {
                navigationController?.pushViewController(SignInViewController(), animated: true)
            } else {
                navigationController?.pushViewController(AccountSettingsViewController(), animated: true)
            }
        default:
            break
        }
    }
    
    // MARK: View Helpers
    
    private func configUserInfoCell(_ cell: UITableViewCell) {
        cell.accessoryType = .disclosureIndicator
        cell.contentView.addSubview(userInfoView)

        userInfoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Internal Helpers

}
