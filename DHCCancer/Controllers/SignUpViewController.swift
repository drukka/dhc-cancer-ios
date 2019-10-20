//
//  SignUpViewController.swift
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

final class SignUpViewController: UIViewController, KeyboardDucking, NVActivityIndicatorViewable {
    @IBOutlet private  weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmationTextField: UITextField!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startDuckingKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopDuckingKeyboard()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    
    private func assignDelegates() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmationTextField.delegate = self
    }
    
    private func setUpValidator() {
        self.validator.add(self.emailTextField, withValidationRule: .email)
        self.validator.add(self.passwordTextField, withValidationRule: .password)
    }
    
    private func validateFields() -> Bool {
        guard case .invalid(let rule) = self.validator.validate() else {
            if self.passwordTextField.text != self.passwordConfirmationTextField.text {
                self.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Your password and password confirmation do not match", comment: ""))
                return false
            } else {
                return true
            }
        }
        
        switch rule {
        case .email:
            self.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Wrong email format", comment: ""))
        case .password:
            self.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Invalid password. The password should be at least 6 characters long and contain 1 uppercase, 1 lowercase and 1 numeric character", comment: ""))
        default:
            self.issueGenericErrorAlert()
        }
        
        return false
    }
    
    private func signUp(email: String, password: String) {
        self.startAnimating()
        
        firstly(execute: {
            self.networking.signUp(email: email, password: password)
        }).ensure({
            self.stopAnimating()
        }).done({ [weak self] authenticationResponse in
            guard let self = self else { return }
            
            self.currentUserProvider.save(with: authenticationResponse.user, authenticationToken: authenticationResponse.token)
            
            let onboardingPageViewController = self.container.resolve(OnboardingPageViewController.self)!
            let onboardingNavigationController = UINavigationController(rootViewController: onboardingPageViewController)
            onboardingNavigationController.modalPresentationStyle = .fullScreen
            self.present(onboardingNavigationController, animated: true, completion: nil)
        }).catch({ [weak self] error in
            guard let networkingError = error as? NetworkingError, case .serviceError(let status) = networkingError else {
                self?.handleError(error)
                return
            }
            
            switch status {
            case .conflict: self?.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("This email is already used", comment: ""))
            default: self?.handleError(networkingError)
            }
        })
    }
    
    @IBAction private func signUpTapped(_ sender: BorderedButton) {
        guard self.validateFields() else { return }
        
        self.signUp(email: self.emailTextField.text!, password: self.passwordTextField.text!)
    }
    
    @IBAction private func logInTapped(_ sender: BorderedButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIResponder methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.passwordTextField.resignFirstResponder()
            self.passwordConfirmationTextField.becomeFirstResponder()
        case self.passwordConfirmationTextField:
            self.passwordConfirmationTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}
