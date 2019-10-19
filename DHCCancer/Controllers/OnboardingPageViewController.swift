//
//  OnboardingPageViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {

    // MARK: - Properties
    
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    
    // MARK: - Initialization
    
    init(networking: Networking, currentUserProvider: CurrentUserProviderProtocol) {
        self.networking = networking
        self.currentUserProvider = currentUserProvider
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
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
