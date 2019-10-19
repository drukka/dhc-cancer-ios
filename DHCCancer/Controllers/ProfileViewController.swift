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
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Profile"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: String(describing: ProfileTableViewCell.self), bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as! ProfileTableViewCell
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "My information"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "Medical documents"
        } else {
            cell.textLabel?.text = "Log history"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Navigate to my information
        } else if indexPath.section == 1 {
            // Navigate to medical documents
        } else {
            // Navigate to log history
        }
    }
}
