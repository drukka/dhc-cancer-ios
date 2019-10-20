//
//  AppDelegate.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject
import AlamofireNetworkActivityIndicator
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    var window: UIWindow?
    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private let appContainer: Container = Container()
    private let appDependencies: AppDependencies = AppDependencies()
    private var currentUserProvider: CurrentUserProviderProtocol!
    private var networking: Networking!
    
    // MARK: - Application life cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.appDependencies.setup(with: self.appContainer)
        self.setupNetworkActivityIndicator()
        self.setupNotifications()
        self.setupCurrentUserProvider()
        self.setupNetworking()
        self.updateUser()
        self.setupDefaultNavigationBarAppearance()
        self.setupWindow()
        return true
    }

    
    // MARK: - Private methods
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().delegate = self

        let authorizationOptions: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions, completionHandler: { _, _ in return })

        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func setupNetworkActivityIndicator() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }

    private func setupCurrentUserProvider() {
        self.currentUserProvider = self.appContainer.resolve(CurrentUserProviderProtocol.self)!
    }

    private func setupNetworking() {
        self.networking = self.appContainer.resolve(Networking.self)!
    }
    
    private func setupDefaultNavigationBarAppearance() {
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().barTintColor = UIColor.clear
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .medium)
        ]
    }

    // MARK: - Public methods
    
    func updateUser() {
        /*guard let authenticationToken = self.currentUserProvider.authenticationToken else { return }
        self.networking.getCurrentUser(token: authenticationToken).done({ userData in
            self.currentUserProvider.update(with: userData)
        }).cauterize()*/
    }
    
    private func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if self.currentUserProvider.authenticationToken != nil {
            self.window?.rootViewController = self.appContainer.resolve(MainTabBarController.self)
        } else {
            self.window?.rootViewController = UINavigationController(rootViewController: self.appContainer.resolve(LoginViewController.self)!)
        }
        
        self.window?.makeKeyAndVisible()
    }

    func assignLoginViewControllerAsRootViewController() {
        //self.window?.rootViewController = UINavigationController(rootViewController: self.appContainer.resolve(LoginViewController.self)!)
    }
    
    func handleSessionExpired() {
        self.currentUserProvider.destroy()
        self.window?.makeKeyAndVisible()
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("Your token is expired. Please log in again!", comment: ""), preferredStyle: .alert)
        //alertController.view.tintColor = UIColor(named: "Shark")
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {_ in
            self.assignLoginViewControllerAsRootViewController()
        }))
        if let navigationController = self.window?.rootViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            visibleViewController.present(alertController, animated: true, completion: nil)
        } else {
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

}

// MARK: UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
