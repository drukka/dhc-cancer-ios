//
//  FirstOnboardingViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class FirstOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private let onboardingPageViewController: OnboardingPageViewController
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var nicknameTextField: UITextField!
    
    // MARK: - Initialization
    
    init(onboardingPageViewController: OnboardingPageViewController) {
        self.onboardingPageViewController = onboardingPageViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private methods

    private func jumpToTheNextViewController() {
        self.onboardingPageViewController.jumpToViewControllerAt(1)
    }
    
    // MARK: - Control events
    
    @IBAction private func nextButtonTapped(_ sender: UIButton) {
        // TODO
        self.jumpToTheNextViewController()
    }
    
    @IBAction private func skipButtonTapped(_ sender: UIButton) {
        // TODO
        self.jumpToTheNextViewController()
    }
    
    
    
    // MARK: - UIResponder methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate methods

extension FirstOnboardingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameTextField:
            return self.nicknameTextField.becomeFirstResponder()
        case self.nicknameTextField:
            return self.nicknameTextField.resignFirstResponder()
        default:
            return false
        }
    }
    
}
