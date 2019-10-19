//
//  FifthOnboardingViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class FifthOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private let onboardingPageViewController: OnboardingPageViewController
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    
    // MARK: - Initialization
    
    init(onboardingPageViewController: OnboardingPageViewController, networking: Networking, currentUserProvider: CurrentUserProviderProtocol) {
        self.onboardingPageViewController = onboardingPageViewController
        self.networking = networking
        self.currentUserProvider = currentUserProvider
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
    
    
}
