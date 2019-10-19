//
//  FourthOnboardingViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject

final class FourthOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private let onboardingPageViewController: OnboardingPageViewController
    private let container: Container
    
    // MARK: - Initialization
    
    init(onboardingPageViewController: OnboardingPageViewController, container: Container) {
        self.onboardingPageViewController = onboardingPageViewController
        self.container = container
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
        self.onboardingPageViewController.jumpToViewControllerAt(4)
    }
    
    // MARK: - Control events
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        self.onboardingPageViewController.updateUserRequest.anonymousShare = true
        self.jumpToTheNextViewController()
    }
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        self.onboardingPageViewController.updateUserRequest.anonymousShare = false
        self.jumpToTheNextViewController()
    }
    
}
