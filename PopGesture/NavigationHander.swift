//
//  NavigationHander.swift
//  PopGesture
//
//  Created by lyf on 2018/9/7.
//  Copyright © 2018年 lyf. All rights reserved.
//

import UIKit

class NavigationHander: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var navigitionCtr: UINavigationController!
    var panRecognizer: UIPanGestureRecognizer!
    
    
    /// 自定义动画，实现了UIViewControllerAnimatedTransitioning协议
    fileprivate var animator: NavigationAnimator?
    /// 负责动画进度管理
    fileprivate var interaction: UIPercentDrivenInteractiveTransition?
    
    /// 要给topview边缘添加阴影。因为原生动画滑动中topview的左边缘是有阴影的，更容易区分两个不同的页面
    fileprivate lazy var uiPopShadow: CAGradientLayer = {
        let shadow = CAGradientLayer()
        shadow.frame = CGRect(x: -6, y: 0, width: 6, height: UIScreen.main.bounds.size.height)
        shadow.startPoint = CGPoint(x: 1, y: 0.5)
        shadow.endPoint = CGPoint(x: 0, y: 0.5)
        shadow.colors = [UIColor.init(white: 0, alpha: 0.2).cgColor, UIColor.clear.cgColor]
        return shadow
    } ()

    
    init(navigationController: UINavigationController) {
        super.init()
        navigitionCtr = navigationController
        addPanGesture()
        createAnimator()
    }
    
    /// 添加滑动手势
    fileprivate func addPanGesture() {
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NavigationHander.panGesture(_:)))
        panRecognizer.delegate = self
//        panRecognizer.delaysTouchesBegan = false
        navigitionCtr.view.addGestureRecognizer(panRecognizer)
    }
    
    
    /// 初始化自定义动画
    fileprivate func createAnimator() {
        animator = NavigationAnimator()
    }
}

//MARK: - UIGestureRecognizerDelegate
extension NavigationHander {
    @objc fileprivate func panGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }
        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: view)
            //左边缘44个单位以内才有效
            if location.x < 44.0, navigitionCtr.viewControllers.count > 1 {
                interaction = UIPercentDrivenInteractiveTransition()
                navigitionCtr .popViewController(animated: true) //会调用UINavigationControllerDelegate
            }
        case .changed:
            let translation = recognizer.translation(in: view)
            //动画整体进度
            interaction?.update(translation.x / view.bounds.width)
        case .ended, .cancelled:
            let location = recognizer.location(in: view)
            if location.x > view.bounds.width * 0.5 {
                interaction?.finish()
            } else {
                interaction?.cancel()
            }
            interaction = nil;
            break
        default:
            break
        }
    }
}

//MARK: - UINavigationControllerDelegate
extension NavigationHander {
    
    //在该协议返回自定义管理动画进度的interaction
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        //触发panGesture才会为interaction赋值，平时返回nil
        return interaction
    }
    
    //在该协议里返回自定义动画
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        animator?.currentOpearation = operation
        var ignoreTabbar = true
        switch operation {
        case .pop:
            fromVC.view.layer.addSublayer(uiPopShadow)
            ignoreTabbar = toVC.hidesBottomBarWhenPushed || !fromVC.hidesBottomBarWhenPushed
        case .push:
            //如果不需要自定义push，可以return nil
            toVC.view.layer.addSublayer(uiPopShadow)
            ignoreTabbar = !toVC.hidesBottomBarWhenPushed || fromVC.hidesBottomBarWhenPushed
        default:
            return nil
        }
        animator?.tabbar = ignoreTabbar ? nil : navigitionCtr.tabBarController?.tabBar
        return animator
    }
}
