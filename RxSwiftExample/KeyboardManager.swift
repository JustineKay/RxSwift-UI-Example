//
//  KeyboardManager.swift
//  RxSwiftExample
//
//  Created by Justine Kay on 8/28/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation
import UIKit

class KeyboardManager: NSObject {
    
    private let animation: ((CGFloat) ->())
    
    init(animation: ((CGFloat) -> ())) {
        self.animation = animation
        super.init()
        self.setupKeyboardNotifications()
    }
    
    private func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_: )), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_: )), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardFrame: NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        animation(keyboardRect.height)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animation(0)
    }
}
