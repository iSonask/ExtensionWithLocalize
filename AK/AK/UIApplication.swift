//
//  UIApplication.swift
//  AK
//
//  Created by SHANI SHAH on 29/11/18.
//

import Foundation
import UIKit

public enum ChangeRootViewControllerAnimation {
    case none
    case transitionCrossDissolve
    case transitionFlipFromRight
    case scale
}

extension UIApplication {
    
    public func universalOpenUrl(_ url: URL) {
        if #available(iOS 10, *) {
            open(url, options: [:],
                 completionHandler: {
                    (success) in
                    print("Open \(url): \(success)")
            })
        } else {
            let success = openURL(url)
            print("Open \(url): \(success)")
        }
        
    }
    
    /// Return the specific topViewController in application
    public class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
    
    
    
    public func switchRootViewController(_ window: UIWindow?, rootViewController: UIViewController, animation: ChangeRootViewControllerAnimation, completion: (() -> Void)?) {
        if let window = window {
            
            switch animation {
            case .none:
                window.rootViewController = rootViewController
            case .transitionFlipFromRight:
                UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromRight, animations: {
                    let oldState: Bool = UIView.areAnimationsEnabled
                    UIView.setAnimationsEnabled(false)
                    window.rootViewController = rootViewController
                    UIView.setAnimationsEnabled(oldState)
                }, completion: { (finished: Bool) -> () in
                    completion?()
                })
                
            case .transitionCrossDissolve:
                UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    let oldState: Bool = UIView.areAnimationsEnabled
                    UIView.setAnimationsEnabled(false)
                    window.rootViewController = rootViewController
                    UIView.setAnimationsEnabled(oldState)
                }, completion: { (finished: Bool) -> () in
                    completion?()
                })
            case .scale:
                let snapshot: UIView = window.snapshotView(afterScreenUpdates: true)!
                rootViewController.view.addSubview(snapshot);
                
                window.rootViewController = rootViewController;
                
                UIView.animate(withDuration: 0.4, animations: {() in
                    snapshot.layer.opacity = 0;
                    snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
                }, completion: {
                    (value: Bool) in
                    snapshot.removeFromSuperview();
                    completion?()
                });
            }
        }
    }
}

extension UIAlertController {
    public func addCancel(title: String) {
        self.addAction(UIAlertAction(title: title, style: .cancel, handler: nil))
    }
    
    public class func showAlert(_ message: String?) {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        UIApplication.topViewController()?.present(ac, animated: true, completion: nil)
    }
}

