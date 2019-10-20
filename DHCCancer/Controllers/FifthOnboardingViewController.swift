//
//  FifthOnboardingViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import PromiseKit
import NVActivityIndicatorView
import Swinject

final class FifthOnboardingViewController: UIViewController, NVActivityIndicatorViewable {

    // MARK: - Properties
    
    private let onboardingPageViewController: OnboardingPageViewController
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    private let container: Container
    
    // MARK: - Initialization
    
    init(onboardingPageViewController: OnboardingPageViewController, networking: Networking, currentUserProvider: CurrentUserProviderProtocol, container: Container) {
        self.onboardingPageViewController = onboardingPageViewController
        self.networking = networking
        self.currentUserProvider = currentUserProvider
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
    
    private func updateUserData() {
        guard let token = self.currentUserProvider.authenticationToken else { return }
        self.startAnimating()
        firstly(execute: {
            self.networking.updateUserData(request: self.onboardingPageViewController.updateUserRequest, token: token)
        }).ensure({
            self.stopAnimating()
        }).done({ [weak self] _ in
            guard let self = self else { return }
            
            let mainNavigationController = UINavigationController(rootViewController: self.container.resolve(MainTabBarController.self)!)
            mainNavigationController.modalPresentationStyle = .currentContext
            self.present(mainNavigationController, animated: true, completion: nil)
        }).cauterize()
    }
    
    // MARK: - Control events
    
    @IBAction private func startButtonTapped(_ sender: UIButton) {
        self.updateUserData()
    }
    
}
