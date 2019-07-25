//
//  VStackView.swift
//  byyh
//
//  Created by hustlzp on 2019/6/24.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit
import SnapKit

class VStackView: UIStackView {
    private var stackViewWidthConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Public Methods
    
    func addRow(_ view: UIView, top: CGFloat, left: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat) {
        let wapView = UIView()
        addArrangedSubview(wapView)
        
        wapView.addSubview(view)
        
        // 约束
        
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(top)
            make.bottom.equalToSuperview().offset(-bottom)
            
            if let left = left, let right = right {
                make.left.equalToSuperview().offset(left)
                make.right.equalToSuperview().offset(-right)
            } else if let left = left {
                make.left.equalToSuperview().offset(left)
            } else if let right = right {
                make.right.equalToSuperview().offset(-right)
            } else {
                make.centerX.equalToSuperview()
            }
        }
    }
    
    func addRow(_ view: UIView, inset: UIEdgeInsets = .zero) {
        self.addRow(view, top: inset.top, left: inset.left, right: inset.right, bottom: inset.bottom)
    }

}
