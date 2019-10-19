//
//  LoginViewController.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject
import PromiseKit
import NVActivityIndicatorView
import KeyboardDucker

final class LoginViewController: UIViewController, KeyboardDucking, NVActivityIndicatorViewable {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    private let validator: ValidatorProtocol
    private let container: Container
    
    // MARK: - Initialization
    
    init(networking: Networking, currentUserProvider: CurrentUserProviderProtocol, validator: ValidatorProtocol, container: Container) {
        self.networking = networking
        self.currentUserProvider = currentUserProvider
        self.validator = validator
        self.container = container
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assignDelegates()
        self.setupValidator()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startDuckingKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopDuckingKeyboard()
    }
    
    // MARK: - Private methods
    
    private func assignDelegates() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    private func setupValidator() {
        self.validator.add(self.emailTextField, withValidationRule: .notNilOrEmpty)
        self.validator.add(self.emailTextField, withValidationRule: .email)
        self.validator.add(self.passwordTextField, withValidationRule: .notNilOrEmpty)
    }
    
    private func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func validateFields() -> Bool {
        let validationResult = self.validator.validate()
        guard case .invalid(let rule) = validationResult else { return true }
        switch rule {
        case .notNilOrEmpty: self.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("All fields are required", comment: ""))
        case .email: self.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Wrong email format", comment: ""))
        default: self.issueGenericErrorAlert()
        }
        return false
    }
    
    private func logIn(email: String, password: String) {
        self.startAnimating()
        firstly(execute: {
            self.networking.logIn(email: email, password: password)
        }).ensure({
            self.stopAnimating()
        }).done({ [weak self] authenticationResponse in
            guard let self = self else { return }
            self.currentUserProvider.save(with: authenticationResponse.user, authenticationToken: authenticationResponse.token)
            
            let onboardingPageViewController = self.container.resolve(OnboardingPageViewController.self)!
            self.present(onboardingPageViewController, animated: true, completion: nil)
        }).catch({ [weak self] error in
            guard let networkingError = error as? NetworkingError, case .serviceError(let status) = networkingError else {
                self?.handleError(error)
                return
            }
            switch status {
            case .unauthorized: self?.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Bad email or password", comment: ""))
            default: self?.handleError(networkingError)
            }
        })
    }

    @IBAction private func logInTapped(_ sender: BorderedButton) {
        guard self.validateFields() else { return }
        
        self.logIn(email: self.emailTextField.text!, password: self.passwordTextField.text!)
    }
    
    @IBAction private func signUpTapped(_ sender: BorderedButton) {
        let signUpViewController = self.container.resolve(SignUpViewController.self)!
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    // MARK: - UIResponder methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
