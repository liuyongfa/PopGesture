//
//  SecondViewController.swift
//  PopGesture
//
//  Created by lyf on 2018/9/13.
//  Copyright © 2018年 lyf. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var panGesture: UIPanGestureRecognizer!
    fileprivate let edgeWidth: CGFloat = 44.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let target = self.navigationController?.interactivePopGestureRecognizer?.delegate
        panGesture = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SecondViewController {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            return location.x < edgeWidth
        }
        return true
    }
}

extension SecondViewController {
        override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
            return .bottom
        }
}
