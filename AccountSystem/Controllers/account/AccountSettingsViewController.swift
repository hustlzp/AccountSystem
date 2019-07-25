//
//  AccountSettingsViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import MBProgressHUD
import PromiseKit
import SDWebImage
import AVOSCloud

class AccountSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateUserInfo), name: .didUpdateUserInfo, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Size.horizonalGap, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 100
        view.addSubview(tableView)
        
        // 约束
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的账户".localized()
    }
    
    // MARK: User Interaction
    
    @objc private func changeAvatar() {
        guard User.current() != nil else { return }
        
        if Utils.checkAlbumAuthDenied() {
            Utils.showAlbumPermissionReuqestAlert(controller: self)
            return
        }
        
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc private func bindWechat() {
        bindSocialAccount(.wechat)
    }
    
    @objc private func unbindWechat(sourceView: UIView?) {
        unbindSocialAccount(.wechat, sourceView: sourceView)
    }
    
    @objc private func bindQQ() {
        bindSocialAccount(.qq)
    }
    
    @objc private func unbindQQ(sourceView: UIView?) {
        unbindSocialAccount(.qq, sourceView: sourceView)
    }
    
    @objc private func bindWeibo() {
        bindSocialAccount(.weibo)
    }
    
    @objc private func unbindWeibo(sourceView: UIView?) {
        unbindSocialAccount(.weibo, sourceView: sourceView)
    }
    
    @objc private func bindTwitter() {
        bindSocialAccount(.twitter)
    }
    
    @objc private func unbindTwitter(sourceView: UIView?) {
        unbindSocialAccount(.twitter, sourceView: sourceView)
    }
    
    @objc private func bindFacebook() {
        bindSocialAccount(.facebook)
    }
    
    @objc private func unbindFacebook(sourceView: UIView?) {
        unbindSocialAccount(.facebook, sourceView: sourceView)
    }
    
    @objc private func signOut(sourceView: UIView?) {
        _ = showConfirmController(style: .actionSheet, title: "确认退出账号？".localized(), confirmText: "退出".localized(), confirmStyle: .destructive, showCancelButton: true, sourceView: sourceView).done({ (_) in
            User.logOut()
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: .didSignOut, object: nil)
        })
    }
    
    // MARK: UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 5
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        guard let user = User.current() else { return cell }
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                configAvatarCell(cell)
            case 1:
                configKeyValueCell(cell, key: "用户名".localized(), value: user.nickname)
            case 2:
                configKeyValueCell(cell, key: "手机号".localized(), value: user.mobilePhoneNumber ?? "未绑定".localized())
            case 3:
                configKeyValueCell(cell, key: "密码".localized(), value: user.didSetPassword ? "" : "未设置".localized())
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                configKeyValueCell(cell, key: "微信".localized(), value: user.didBindWechat ? "已绑定".localized() : "未绑定".localized())
            case 1:
                configKeyValueCell(cell, key: "微博".localized(), value: user.didBindWeibo ? "已绑定".localized() : "未绑定".localized())
            case 2:
                configKeyValueCell(cell, key: "QQ", value: user.didBindQQ ? "已绑定".localized() : "未绑定".localized())
            case 3:
                configKeyValueCell(cell, key: "Twitter", value: user.didBindTwitter ? "已绑定".localized() : "未绑定".localized())
            case 4:
                configKeyValueCell(cell, key: "Facebook", value: user.didBindFacebook ? "已绑定".localized() : "未绑定".localized())
            default:
                break
            }
        case 2:
            configSignOutCell(cell)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let user = User.current() else { return }
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                changeAvatar()
            case 1:
                navigationController?.pushViewController(ChangeNicknameViewController(), animated: true)
            case 2:
                if Utils.isEmpty(user.mobilePhoneNumber) {
                    navigationController?.pushViewController(SetPhoneViewController(), animated: true)
                } else {
                    navigationController?.pushViewController(ChangePhoneViewController(), animated: true)
                }
            case 3:
                if user.didSetPassword {
                    navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
                } else if !Utils.isEmpty(user.mobilePhoneNumber) {
                    navigationController?.pushViewController(SetPasswordViewController(), animated: true)
                } else {
                    MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "请先绑定手机号".localized())
                }
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                user.didBindWechat ? unbindWechat(sourceView: cell) : bindWechat()
            case 1:
                user.didBindWeibo ? unbindWeibo(sourceView: cell) : bindWeibo()
            case 2:
                user.didBindQQ ? unbindQQ(sourceView: cell) : bindQQ()
            case 3:
                user.didBindTwitter ? unbindTwitter(sourceView: cell) : bindTwitter()
            case 4:
                user.didBindFacebook ? unbindFacebook(sourceView: cell) : bindFacebook()
            default:
                break
            }
        case 2:
            self.signOut(sourceView: tableView.cellForRow(at: indexPath))
        default:
            break
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let avatar = info[.originalImage] as? UIImage else {
            MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "上传失败".localized())
            return
        }
        
        guard let user = User.current() else { return }
        
        dismiss(animated: true) {
            guard let croppedImage = avatar.centerCrop(400), let data = croppedImage.jpegData(compressionQuality: 0.9) else {
                MBProgressHUD.showForInfo(UIApplication.shared.keyWindow!, text: "上传失败".localized())
                return
            }
            
            let file = AVFile(data: data)
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "上传中".localized()
            
            file.upload(.promise).then({ (_) -> Promise<User> in
                user.avatar = file
                return user.save(.promise)
            }).done({ (_) in
                hud.hide(animated: true)
                self.tableView.reloadData()
                NotificationCenter.default.post(name: .didUpdateUserInfo, object: nil)
            }).catch({ (error) in
                hud.hideForError(error)
            })
        }
    }
    
    // MARK: Notification Handler
    
    @objc private func didUpdateUserInfo() {
        tableView?.reloadData()
    }
    
    // MARK: View Helpers
    
    private func configAvatarCell(_ cell: UITableViewCell) {
        cell.accessoryType = .disclosureIndicator
        
        let avatarView = UIImageView()
        if let urlString = User.current()?.avatar?.url(), let url = URL(string: urlString) {
            avatarView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultAvatar"))
        } else {
            avatarView.image = UIImage(named: "defaultAvatar")
        }
        avatarView.layer.cornerRadius = 35
        avatarView.layer.masksToBounds = true
        cell.contentView.addSubview(avatarView)
        
        // 约束
        
        avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Size.horizonalGap)
            make.top.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-17)
            make.width.height.equalTo(70)
        }
    }
    
    private func configKeyValueCell(_ cell: UITableViewCell, key: String, value: String?) {
        cell.accessoryType = .disclosureIndicator
        
        let keyLabel = UILabel()
        keyLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        keyLabel.textColor = UIColor.black
        keyLabel.text = key
        cell.contentView.addSubview(keyLabel)
        
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 17)
        valueLabel.textColor = UIColor.lightGray
        valueLabel.text = value
        cell.contentView.addSubview(valueLabel)
        
        // 约束
        
        keyLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(Size.horizonalGap)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
        }
    }
    
    private func configSignOutCell(_ cell: UITableViewCell) {
        cell.accessoryType = .disclosureIndicator
        
        let keyLabel = UILabel()
        keyLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        keyLabel.text = "退出登录".localized()
        cell.contentView.addSubview(keyLabel)
        
        // 约束
        
        keyLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(Size.horizonalGap)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: Internal Helpers
    
    // 取消绑定第三方账号
    private func unbindSocialAccount(_ platform: SocialPlatform, sourceView: UIView?) {
        guard let user = User.current() else { return }
        
        showConfirmController(style: .alert, title: "确认解绑\(platform.name)吗？".localized(), confirmText: "解绑".localized(), confirmStyle: .default, sourceView: sourceView).then { (_) -> Promise<Void> in
            return user.disassociate(.promise, platformId: platform.platformIdForLeanCloud)
        }.done { (_) in
            user[keyPath: platform.didSetKeyPath] = false
            user.saveInBackground()
            self.tableView.reloadData()
            MBProgressHUD.showForSuccess(view: self.view, text: "解绑成功".localized(), duration: 1, completion: nil)
        }.catch { (error) in
            MBProgressHUD.showForError(self.view, error: error)
        }
    }
    
    // 绑定第三方账户
    private func bindSocialAccount(_ platform: SocialPlatform) {
        guard let user = User.current() else { return }
        
        UMSocialManager.default()?.getUserInfo(.promise, platformType: platform.platformTypeForUM, currentViewController: self).done { (response) in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let authDataAndOption = Utils.getAuthDateAndOptionFromUMResponse(response, platform: platform)
            
            guard let authData = authDataAndOption.authData else {
                hud.hideForError(MyError.custom(errorDescription: "\(platform.name)绑定失败".localized()))
                return
            }
            
            let option = authDataAndOption.option
            
            user.associate(.promise, authData: authData, platformId: platform.platformIdForLeanCloud, options: option).done { (_) in
                self.continueBinding(platform: platform, response: response, currentUser: user, hud: hud)
            }.catch { (error) in
                if (error as NSError?)?.code == 137 {
                    hud.hideForInfo("该\(platform.name)账户已被其他用户绑定".localized())
                } else {
                    hud.hideForError(error)
                }
            }
        }.catch { (error) in
            MBProgressHUD.showForError(UIApplication.shared.keyWindow!, error: error)
        }
    }
    
    private func continueBinding(platform: SocialPlatform, response: UMSocialUserInfoResponse, currentUser: User, hud: MBProgressHUD) {
        let finishBindingClosure = {
            self.finishBinding(platform: platform, response: response, currentUser: currentUser, hud: hud)
        }
        
        // 头像
        guard let iconUrlString = response.iconurl, let iconUrl = URL(string: iconUrlString), currentUser.avatar == nil else {
            finishBindingClosure()
            return
        }
        
        SDWebImageDownloader.shared.downloadImage(with: iconUrl, options: SDWebImageDownloaderOptions(rawValue: 0), progress: nil) { (image, data, error, _) in
            guard let data = data, error == nil else {
                finishBindingClosure()
                return
            }
            
            let avatar = AVFile(data: data)
            avatar.upload(.promise).done { (avatar) in
                currentUser.avatar = avatar
                finishBindingClosure()
            }.catch { (error) in
                finishBindingClosure()
            }
        }
    }
    
    private func finishBinding(platform: SocialPlatform, response: UMSocialUserInfoResponse, currentUser: User, hud: MBProgressHUD) {
        // 用户名
        if let name = response.name, currentUser.nickname == nil {
            currentUser.nickname = name
        }
        
        currentUser[keyPath: platform.didSetKeyPath] = true
        currentUser.saveInBackground()
        
        after(seconds: 0.5).done { (_) in
            hud.hideForSuccess("绑定成功".localized())
            self.tableView.reloadData()
        }
    }
}
