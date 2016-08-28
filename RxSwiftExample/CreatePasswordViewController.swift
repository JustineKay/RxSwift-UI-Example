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
    
    private var keyboardMGR: KeyboardManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpKeyboardManager()
    }
    
    private func setUpTextFields() {
        passwordTextField.inputFieldStyle()
        confirmPasswordTextField.inputFieldStyle()
    }
    
    // MARK: - KeyboardManager
    
    private func setUpKeyboardManager() {
        keyboardMGR = KeyboardManager { keyboardHeight in
            self.animateNextButtonWithKeyboardHeight(keyboardHeight)
        }
    }
    
    // MARK: - Animation
    
    private func animateNextButtonWithKeyboardHeight(height: CGFloat) {
        UIView.animateWithDuration(1.5) {
            self.nextButtonBottomConstraint.constant = height
        }
    }
}
