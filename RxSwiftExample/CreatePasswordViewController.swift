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
    @IBOutlet weak var passwordMinCheckboxView: UIImageView!
    @IBOutlet weak var passwordMinCheckboxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordMinCheckboxLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordsMatchLabel: UILabel!
    @IBOutlet weak var passwordsMatchCheckboxView: UIImageView!
    @IBOutlet weak var passwordsMatchWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordsMatchLeadingConstraint: NSLayoutConstraint!
    
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
        configureMinLengthCheckboxConstraints()
        configurePasswordsMatchCheckboxConstraints()
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
            Observable.combineLatest(viewModel.passwordIsMinLength.asObservable(), observable) { $0 && $1 }
                .bindTo(nextButton.rx_enabled)
                .addDisposableTo(viewModel.disposeBag)
            
            Observable.combineLatest(viewModel.passwordIsMinLength.asObservable(), observable) { !($0 && $1) }
                .bindTo(passwordsMatchCheckboxView.rx_hidden)
                .addDisposableTo(viewModel.disposeBag)
        }
        
        viewModel.passwordMinLengthCheckboxHidden.asObservable()
            .bindTo(passwordMinCheckboxView.rx_hidden)
            .addDisposableTo(viewModel.disposeBag)
    }
    
    // MARK: - UITextField Notifications
    
    private func setUpTextFieldNotifications() {
        // TODO: - Rx-ify these
        confirmPasswordTextField.addTarget(self, action: #selector(CreatePasswordViewController.confirmationTextFieldEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.addTarget(self, action: #selector(CreatePasswordViewController.passwordTextFieldEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func passwordTextFieldEditingChanged() {
        configureMinLengthCheckboxConstraints()
    }
    
    func confirmationTextFieldEditingChanged() {
        configurePasswordsMatchCheckboxConstraints()
    }
    
    private func configureMinLengthCheckboxConstraints() {
        passwordMinCheckboxWidthConstraint.constant = passwordMinCheckboxView.hidden ? 0 : 19.5
        passwordMinCheckboxLeadingConstraint.constant = passwordMinCheckboxView.hidden ? 0 : 12
    }
    
    private func configurePasswordsMatchCheckboxConstraints() {
        passwordsMatchWidthConstraint.constant = passwordsMatchCheckboxView.hidden ? 0 : 19.5
        passwordsMatchLeadingConstraint.constant = passwordsMatchCheckboxView.hidden ? 0 : 12
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
