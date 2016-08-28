//
//  CreatePasswordViewController.swift
//  RxSwiftExample
//
//  Created by Justine Kay on 8/27/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    let viewModel = CreatePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.enabled = false
        setUpTextFields()
        setUpKeyboardManager()
        bindToViewModel()
        setUpTextFieldNotifications()
    }
    
    private func setUpTextFields() {
        passwordTextField.inputFieldStyle()
        confirmPasswordTextField.inputFieldStyle()
    }
    
    // MARK: - Rx
    
    private func bindToViewModel() {
        passwordTextField.rx_text
            .bindTo(viewModel.password)
            .addDisposableTo(viewModel.disposeBag)
        
        confirmPasswordTextField.rx_text
            .bindTo(viewModel.passwordConfirmation)
            .addDisposableTo(viewModel.disposeBag)

        if let observable = viewModel.passwordsMatchObservable {
            Observable.combineLatest(viewModel.passwordIsMinLength.asObservable(), observable) { $0 && $1 }.bindTo(nextButton.rx_enabled)
            .addDisposableTo(viewModel.disposeBag)
            
            observable
            .bindTo(passwordsMatchLabel.rx_hidden)
            .addDisposableTo(viewModel.disposeBag)
        }
        
        viewModel.passwordIsMinLength.asObservable()
            .bindTo(passwordMinLabel.rx_hidden)
            .addDisposableTo(viewModel.disposeBag)
    }
    
    // MARK: - UITextField Notifications
    
    private func setUpTextFieldNotifications() {
        // TODO: - Rx-ify these
        confirmPasswordTextField.addTarget(self, action: #selector(CreatePasswordViewController.confirmationTextFieldEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.addTarget(self, action: #selector(CreatePasswordViewController.passwordTextFieldEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func passwordTextFieldEditingChanged() {
        if let text = confirmPasswordTextField.text {
            if passwordMinLabel.hidden && !text.isEmpty {
                passwordsMatchLabel.hidden = passwordTextField.text == confirmPasswordTextField.text
            } else if   text.isEmpty {
                passwordsMatchLabel.hidden = true
            } else {
                passwordsMatchLabel.hidden = !passwordMinLabel.hidden
            }
        }
    }
    
    func confirmationTextFieldEditingChanged() {
        if passwordMinLabel.hidden {
            passwordsMatchLabel.hidden = passwordTextField.text == confirmPasswordTextField.text
        }
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
