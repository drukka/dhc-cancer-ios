//
//  OnboardingPageViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject
import KeyboardDucker

final class OnboardingPageViewController: UIPageViewController, KeyboardDucking {

    // MARK: - Properties
    
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    private let container: Container
    
    private let pageControl = UIPageControl()
    private var controllers = [UIViewController]()
    
    var updateUserRequest: UpdateUserRequest = UpdateUserRequest()
    
    // MARK: - Initialization
    
    init(networking: Networking, currentUserProvider: CurrentUserProviderProtocol, container: Container) {
        self.networking = networking
        self.currentUserProvider = currentUserProvider
        self.container = container
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.setupNavigationBar()
        self.setupPageControl()
        self.setupControllers()
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
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(image: UIImage(named: "BackgroundImage"))
        backgroundImageView.frame = self.view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
    
    private func setupNavigationBar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        self.navigationController?.navigationBar.barStyle = .black

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupPageControl() {
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = 5
        self.pageControl.tintColor = UIColor(named: "SweetCorn")
        
        self.view.addSubview(pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func setupControllers() {
        self.controllers = [
            self.container.resolve(FirstOnboardingViewController.self, argument: self)!,
            self.container.resolve(SecondOnboardingViewController.self, argument: self)!,
            self.container.resolve(ThirdOnboardingViewController.self, argument: self)!,
            self.container.resolve(FourthOnboardingViewController.self, argument: self)!,
            self.container.resolve(FifthOnboardingViewController.self, argument: self)!
        ]
        
        self.setViewControllers([self.controllers.first!], direction: .forward, animated: false, completion: nil)
        self.pageControl.currentPage = 0
    }
    
    // MARK: - Public methods
    
    func jumpToViewControllerAt(_ index: Int) {
        guard let viewController = self.controllers[safe: index] else { return }
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = index
    }

}
