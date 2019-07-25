//
//  StackViewController.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
    private(set) var scrollView: UIScrollView!
    private(set) var stackView: VStackView!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        let scrollContentView = createScrollContentView()
        scrollView.addSubview(scrollContentView)
        
        // 约束
        
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(view)
        }
        
        scrollContentView.snp.makeConstraints { (make) in
            make.edges.width.equalTo(scrollView)
        }
    }
    
    private func createScrollContentView() -> UIView {
        let wapView = UIView()
        
        stackView = VStackView()
        wapView.addSubview(stackView)
        
        // 约束
        
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return wapView
    }
}
