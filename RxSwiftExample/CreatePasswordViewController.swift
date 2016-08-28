//
//  CreatePasswordViewController.swift
//  RxSwiftExample
//
//  Created by Justine Kay on 8/27/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

class CreatePasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordMinLabel: UILabel!
    @IBOutlet weak var passwordsMatchLabel: UILabel!
    @IBOutlet weak var nextButton: NextButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    private let kTransformScale: CGFloat = 1.1
    private let kOriginalScale: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpKeyboardNotifications()
    }
    
    private func setUpTextFields() {
        passwordTextField.inputFieldStyle()
        confirmPasswordTextField.inputFieldStyle()
    }
    
    // MARK: - UITextField / Keyboard
    
    private func setUpKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_: )), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_: )), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardFrame: NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        animateKeyboardWillShow(keyboardRect.height)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateKeyboardWillHide()
    }

    // MARK: - Animations
    
    private func animateKeyboardWillShow(height: CGFloat) {
        UIView.animateWithDuration(2.0, delay: 0, options: .CurveEaseInOut, animations: {
            self.nextButtonBottomConstraint.constant = height
        }) { _ in
            self.pulseAnimation()
        }
    }
    
    private func animateKeyboardWillHide() {
        UIView.animateWithDuration(2.0, delay: 0, options: .CurveEaseInOut, animations: {
            self.nextButtonBottomConstraint.constant = 0
        }) { _ in
            self.pulseAnimation()
        }
    }
    
    private func pulseAnimation() {
        UIView.animateWithDuration(
            0.25,
            animations: {
                self.nextButton.transform = CGAffineTransformMakeScale(self.kTransformScale, self.kTransformScale)
        }) { _ in
            UIView.animateWithDuration(
                0.25,
                animations: {
                    self.nextButton.transform = CGAffineTransformMakeScale(self.kOriginalScale, self.kOriginalScale)
                }, completion: nil
            )
        }
    }
}

