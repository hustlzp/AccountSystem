//
//  UserInfoView.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import Localize_Swift

class UserInfoView: UIView {
    private var avatarView: UIImageView!
    private var nameLabel: UILabel!
    private var actionLabel: UILabel!
    
    private var isAnonymous: Bool {
        return User.current()?.isAnonymous() ?? true
    }
    private var user: User? {
        return User.current()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatarView = UIImageView()
        avatarView.layer.cornerRadius = 35
        avatarView.layer.masksToBounds = true
        addSubview(avatarView)
        
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(nameLabel)
        
        actionLabel = UILabel()
        actionLabel.textColor = UIColor.lightGray
        actionLabel.font = UIFont.systemFont(ofSize: 17)
        addSubview(actionLabel)
        
        // 约束
        
        avatarView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(Size.horizonalGap)
            make.top.equalTo(self).offset(18)
            make.bottom.equalTo(self).offset(-18)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(avatarView.snp.right).offset(15)
        }
        
        actionLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(0)
            make.left.greaterThanOrEqualTo(nameLabel.snp.right).offset(15)
        }
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public Methods
    
    func update() {
        if let urlString = User.current()?.avatar?.url(), let url = URL(string: urlString) {
            avatarView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultAvatar"))
        } else {
            avatarView.image = UIImage(named: "defaultAvatar")
        }
        
        if isAnonymous {
            nameLabel.text = "游客".localized()
            actionLabel.text = "登录 / 注册".localized()
        } else {
            nameLabel.text = user?.nickname
            actionLabel.text = "帐户".localized()
        }
    }

}
