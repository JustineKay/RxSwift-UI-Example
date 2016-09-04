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
    
    @IBOutlet weak var passwordMinCheckmark: UIImageView!
    @IBOutlet weak var passwordMinCheckmarkWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordMinCheckmarkLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordsMatchCheckmark: UIImageView!
    @IBOutlet weak var passwordsMatchCheckmarkWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordsMatchCheckmarkLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: NextButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lockIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lockIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var createPasswordLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextFieldTopConstraint: NSLayoutConstraint!
    
    private var keyboardMGR: KeyboardManager?
    let viewModel = CreatePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.enabled = false
        setUpTextFields()
        setUpKeyboardManager()
        bindToViewModel()
        setUpTextFieldNotifications()
        configurePasswordMinCheckmarkConstraints()
        configurePasswordsMatchCheckmarkConstraints()
        configureConstraintsForScreenSize()
    }
    
    // MARK: - UI
    
    private func setUpTextFields() {
        passwordTextField.inputFieldStyle()
        confirmPasswordTextField.inputFieldStyle()
    }
    
    private func configureConstraintsForScreenSize() {
        if ScreenSize.isIPhone4 {
            lockIconTopConstraint.constant = 12
            lockIconWidthConstraint.constant = 0
            createPasswordLabelTopConstraint.constant = 0
            passwordTextFieldTopConstraint.constant = 20
        } else if ScreenSize.isIPhone5 {
            lockIconWidthConstraint.constant = 50
            createPasswordLabelTopConstraint.constant = 8
            passwordTextFieldTopConstraint.constant = 25
        }
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
            Observable.combineLatest(viewModel.passwordIsMinLength.asObservable(), observable) { $0 && $1 }
                .bindTo(nextButton.rx_enabled)
                .addDisposableTo(viewModel.disposeBag)
            
            Observable.combineLatest(viewModel.passwordIsMinLength.asObservable(), observable) { !($0 && $1) }
                .bindTo(passwordsMatchCheckmark.rx_hidden)
                .addDisposableTo(viewModel.disposeBag)
        }
        
        viewModel.passwordMinCheckmarkHidden.asObservable()
            .bindTo(passwordMinCheckmark.rx_hidden)
            .addDisposableTo(viewModel.disposeBag)
    }
    
    // MARK: - UITextField Notifications
    
    private func setUpTextFieldNotifications() {
        confirmPasswordTextField.addTarget(self, action: #selector(CreatePasswordViewController.confirmationTextFieldEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.addTarget(self, action: #selector(CreatePasswordViewController.passwordTextFieldEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func passwordTextFieldEditingChanged() {
        configurePasswordMinCheckmarkConstraints()
    }
    
    func confirmationTextFieldEditingChanged() {
        configurePasswordsMatchCheckmarkConstraints()
    }
    
    private func configurePasswordMinCheckmarkConstraints() {
        passwordMinCheckmarkWidthConstraint.constant = passwordMinCheckmark.hidden ? 0 : 19.5
        passwordMinCheckmarkLeadingConstraint.constant = passwordMinCheckmark.hidden ? 0 : 12
    }
    
    private func configurePasswordsMatchCheckmarkConstraints() {
        passwordsMatchCheckmarkWidthConstraint.constant = passwordsMatchCheckmark.hidden ? 0 : 19.5
        passwordsMatchCheckmarkLeadingConstraint.constant = passwordsMatchCheckmark.hidden ? 0 : 12
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
