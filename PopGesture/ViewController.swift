//
//  ViewController.swift
//  PopGesture
//
//  Created by lyf on 2018/9/7.
//  Copyright © 2018年 lyf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var navigationHander:NavigationHander!
    
    @IBOutlet weak var bn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let nav = navigationController {
            //添加滑动返回
            navigationHander = NavigationHander(navigationController: nav)
            nav.delegate = navigationHander
        }
        
//        let image = UIImage(named: "icon_back_normal")?.withRenderingMode(.alwaysOriginal)
//        navigationController?.navigationBar.backIndicatorImage = image
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
//        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem = backItem
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        bn.frame.origin.x = 0
    }
}

