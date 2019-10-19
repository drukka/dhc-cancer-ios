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
        self.registerLoginViewController(to: container)
        self.registerSignUpViewController(to: container)
        self.registerProfileViewController(to: container)
        self.registerMyInformationViewController(to: container)
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
            return OnboardingPageViewController(networking: container.resolve(Networking.self)!, currentUserProvider: container.resolve(CurrentUserProviderProtocol.self)!, container: container)
        })
    }
    
    private func registerFirstOnboardingViewController(to container: Container) {
        container.register(FirstOnboardingViewController.self, factory: { _, onboardingPageViewController in
            return FirstOnboardingViewController(onboardingPageViewController: onboardingPageViewController)
        })
    }
    
    private func registerLoginViewController(to container: Container) {
        container.register(LoginViewController.self, factory: { _ in
            return LoginViewController(
                networking: container.resolve(Networking.self)!,
                currentUserProvider: container.resolve(CurrentUserProviderProtocol.self)!,
                validator: container.resolve(ValidatorProtocol.self)!,
                container: container
            )
        })
    }
    
    private func registerSignUpViewController(to container: Container) {
        container.register(SignUpViewController.self, factory: { _ in
            return SignUpViewController(
                networking: container.resolve(Networking.self)!,
                currentUserProvider: container.resolve(CurrentUserProviderProtocol.self)!,
                validator: container.resolve(ValidatorProtocol.self)!,
                container: container
            )
        })
    }
    
    private func registerProfileViewController(to container: Container) {
        container.register(ProfileViewController.self, factory: { _ in
            return ProfileViewController(networking: container.resolve(Networking.self)!,
                currentUserProvider: container.resolve(CurrentUserProviderProtocol.self)!,
                container: container)
        })
    }
    
    private func registerMyInformationViewController(to container: Container) {
        container.register(MyInformationViewController.self, factory: { _ in
            return MyInformationViewController(networking: container.resolve(Networking.self)!,
                currentUserProvider: container.resolve(CurrentUserProviderProtocol.self)!,
                container: container)
        })
    }
}
