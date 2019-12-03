//
//  ViewController.swift
//  Sankey
//
//  Created by Jae Lee on 12/2/19.
//  Copyright © 2019 Jae Lee. All rights reserved.
//

import UIKit
struct Buyer {
    var name:String
}

struct Seller {
    var name:String
}

class ViewController: UIViewController {
    
    
    var scrollView:SankeyView!
    var contentView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        view.backgroundColor = UIColor.white
        
        setup()
    }
    
    fileprivate func setup() {
        setupScrollView()
    }
    
    fileprivate func setupScrollView() {
        scrollView = SankeyView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    



}

