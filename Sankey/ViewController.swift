//
//  ViewController.swift
//  Sankey
//
//  Created by Jae Lee on 12/2/19.
//  Copyright © 2019 Jae Lee. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    var sankeyView:SankeyView!
    var contentView:UIView!
    
    var sankeyItems:[String:[SankeyItem]] = [
        "seller 1":  [SankeyItem(name: "buyer A", volume: 5),SankeyItem(name: "buyer B", volume: 10),SankeyItem(name: "buyer C", volume: 15)],
        "seller 2":  [SankeyItem(name: "buyer A", volume: 1),SankeyItem(name: "buyer B", volume: 3),SankeyItem(name: "buyer C", volume: 5)],
        "seller 3":  [SankeyItem(name: "buyer A", volume: 3)],
        "seller 4":  [SankeyItem(name: "buyer A", volume: 5),SankeyItem(name: "buyer B", volume: 10),SankeyItem(name: "buyer C", volume: 15)],
        "seller 5":  [SankeyItem(name: "buyer A", volume: 1),SankeyItem(name: "buyer B", volume: 3),SankeyItem(name: "buyer C", volume: 5),SankeyItem(name: "buyer D", volume: 3),SankeyItem(name: "buyer E", volume: 5),SankeyItem(name: "buyer F", volume: 1),SankeyItem(name: "buyer G", volume: 3),SankeyItem(name: "buyer H", volume: 10)],
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        view.backgroundColor = UIColor.white
        
        setup()
    }
    
    fileprivate func setup() {
        setupScrollView()
        sankeyView.drawSankey()
    }
    
    fileprivate func setupScrollView() {
        sankeyView = SankeyView()
        sankeyView.backgroundColor = .clear
        sankeyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sankeyView)
        
        NSLayoutConstraint.activate([
            sankeyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sankeyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sankeyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sankeyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sankeyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sankeyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    



}

