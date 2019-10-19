//
//  ProfileViewController.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject
import PromiseKit
import NVActivityIndicatorView

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableHeaderView = ProfileHeaderView()
    
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    private let container: Container
    
    // MARK: - Initialization
    
    init(networking: Networking, currentUserProvider: CurrentUserProviderProtocol, container: Container) {
        self.networking = networking
        self.currentUserProvider = currentUserProvider
        self.container = container
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Profile"
//        setUpTableHeaderView()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setUpTableHeaderView()
        
        
    }
    
    private func setUpTableHeaderView() {
        tableView.layoutIfNeeded()
        
        tableHeaderView = Bundle.main.loadNibNamed(String(describing: ProfileHeaderView.self), owner: nil, options: nil)?.first as! ProfileHeaderView
        tableHeaderView.frame.size = CGSize(width: view.bounds.width, height: ProfileHeaderView.height)
        self.tableView.tableHeaderView = tableHeaderView
    }
}
