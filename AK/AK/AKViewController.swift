//
//  AKViewController.swift
//  AK
//
//  Created by SHANI SHAH on 29/11/18.
//

import Foundation
import UIKit

///Base class for safe use view controllers
open class AKViewController: UIViewController {
    public var notificationManager: AKNotificationManager = AKNotificationManager()
    
    open  class func showController(_ parent: AKViewController, data: [String:Any]? = nil) {
        if let controller = getController(data) {
            parent.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    open func controllerClose() {
        navigationController?.popViewController(animated: true)
    }
    
    
    /// Init controller with data. Should return false if data is incorrect or controller could not be initialized
    ///
    /// - Parameter data: dictionary with data
    open func initController(_ data: [String:Any]?) -> Bool {
        return true
    }
    
    
    
    //MARK: View Life
    deinit {
        notificationManager.deregisterAll()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    
    //MARK: Public
    
    open class var storyboardName: String { return "" }
    open class var controllerIdentifier: String {  return "" }
    
    public class func getController(_ data: [String:Any]? = nil) -> AKViewController? {
        let controller = getViewController()
        if !controller.initController(data) {
            return nil
        }
        return controller
    }
    
    class func getViewController() -> AKViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        var identifier = controllerIdentifier
        if identifier.isEmpty {
            identifier = "\(self)"
        }
        return storyboard.instantiateViewController(withIdentifier: identifier) as! AKViewController
    }
    
    // MARK: Keyboard
    
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //To not prevent other tap events
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.view.endEditing(true)
        }
    }
    
}


/// Class provide the ability to subscribe for NotificationCenter notifications in different queues.
open class AKNotificationManager {
    fileprivate var observerTokens: [NotificationTokenWithName] = []
    
    struct NotificationTokenWithName {
        var token: NSObjectProtocol
        var name: Notification.Name
    }
    
    public init() {
        
    }
    
    deinit {
        deregisterAll()
    }
    
    
    /// Unregister for all registered observers
    open func deregisterAll() {
        for token in observerTokens {
            NotificationCenter.default.removeObserver(token.token)
        }
        
        observerTokens.removeAll(keepingCapacity: false)
    }
    
    
    /// Unregister observer by Notification.Name
    ///
    /// - Parameter name: name of the notification to remove observer
    open func unregisterObserver(name: Notification.Name) {
        if let index = observerTokens.index(where: { $0.name.rawValue == name.rawValue }) {
            NotificationCenter.default.removeObserver(observerTokens[index])
            observerTokens.remove(at: index)
        }
    }
    
    /// Register main thread observer
    ///
    /// - Parameters:
    ///   - name: notification name
    ///   - block: It is very important to use block as {[weak self] (note: Notification) in
    /// - Returns: object of added observer
    @discardableResult
    open func registerMTObserver(_ name: Notification.Name, block: @escaping ((_ notification: Notification) -> Void)) -> NSObjectProtocol {
        let newToken = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) {note in
            DispatchQueue.main.async {
                block(note)
            }
        }
        
        observerTokens.append(NotificationTokenWithName(token: newToken, name: name))
        return newToken
    }
    
    /// Register background thread observer
    ///
    /// - Parameters:
    ///   - name: notification name
    ///   - block: It is very important to use block as {[weak self] (note: Notification) in
    /// - Returns: object of added observer
    @discardableResult
    open func registerBTObserver(_ name: Notification.Name, block: @escaping ((_ notification: Notification) -> Void)) -> NSObjectProtocol {
        let newToken = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { note in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                block(note)
            }
        }
        
        observerTokens.append(NotificationTokenWithName(token: newToken, name: name))
        return newToken
    }
}
