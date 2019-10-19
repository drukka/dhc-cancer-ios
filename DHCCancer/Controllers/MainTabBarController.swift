//
//  MainTabBarController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject

final class MainTabBarController: UITabBarController {

    // MARK: - Properties
    
    private let container: Container
    
    // MARK: - Initialization
    
    init(container: Container) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControllers()
        
    }
    
    // MARK: - Private methods

    private func setupControllers() {
        self.tabBar.tintColor = UIColor(named: "Hibiscus")
        
        let profileViewController = UINavigationController(rootViewController: UIViewController())
        profileViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "Profile"), selectedImage: nil)
        
        let calendarViewController = UINavigationController(rootViewController: UIViewController())
        calendarViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Calendar", comment: ""), image: UIImage(named: "Calendar"), selectedImage: nil)
        
        let quickLogViewController = UINavigationController(rootViewController: UIViewController())
        quickLogViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Quick log", comment: ""), image: nil, selectedImage: nil)
        
        let communityViewController = UINavigationController(rootViewController: UIViewController())
        communityViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Community", comment: ""), image: UIImage(named: "Comments"), selectedImage: nil)
        
        let settingsViewController = UINavigationController(rootViewController: UIViewController())
        settingsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings", comment: ""), image: UIImage(named: "Cog"), selectedImage: nil)
        
        self.viewControllers = [profileViewController, calendarViewController, quickLogViewController, communityViewController, settingsViewController]
        
        let addButton = UIButton()
        addButton.setBackgroundImage(UIImage(named: "Add"), for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.tabBar.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 8.0)
        ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - Control events
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let quickLogView = UINavigationController(rootViewController: UIViewController())
        quickLogView.modalPresentationStyle = .fullScreen
        self.present(quickLogView, animated: true, completion: nil)
        
    }
}
