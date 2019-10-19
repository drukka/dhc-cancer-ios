//
//  AppDependencies.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 05. 27..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation
import Swinject

final class AppDependencies {
    
    // MARK: - Public methods
    
    func setup(with container: Container) {
        self.registerNetworking(to: container)
        self.registerCurrentUserProvider(to: container)
        self.registerValidator(to: container)
        self.registerOnboardingPageViewController(to: container)
        self.registerFirstOnboardingViewController(to: container)
    }
    
    // MARK: - Private methods
    
    private func registerNetworking(to container: Container) {
        container.register(Networking.self, factory: { _ in
            #if MOCK
                return FakeAPIClient()
            #else
                return APIClient()
            #endif
        })
    }
    
    private func registerCurrentUserProvider(to container: Container) {
        container.register(CurrentUserProviderProtocol.self, factory: { _ in
            #if MOCK
                return FakeCurrentUserProvider()
            #else
                return CurrentUserProvider()
            #endif
        })
    }
    
    private func registerValidator(to container: Container) {
        container.register(ValidatorProtocol.self, factory: { _ in
            return Validator()
        })
    }
    
    private func registerOnboardingPageViewController(to container: Container) {
        container.register(OnboardingPageViewController.self, factory: { _ in
            return OnboardingPageViewController(networking: container.resolve(Networking.self)!, currentUserProvider: container.resolve(CurrentUserProviderProtocol.self)!)
        })
    }
    
    private func registerFirstOnboardingViewController(to container: Container) {
        container.register(FirstOnboardingViewController.self, factory: { _, onboardingPageViewController in
            return FirstOnboardingViewController(onboardingPageViewController: onboardingPageViewController)
        })
    }
    
}
