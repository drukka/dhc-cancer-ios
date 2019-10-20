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

class ProfileViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableHeaderView = ProfileHeaderView()
    
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    private let container: Container
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            tableHeaderView.user = user
        }
    }
    
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
        
        self.setupNavigationBar()
        self.title = "Profile"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: String(describing: ProfileTableViewCell.self), bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
        
        fetchProfileDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setUpTableHeaderView()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchProfileDetails() {
        guard let authenticationToken = self.currentUserProvider.authenticationToken else { return }
        self.startAnimating()
        
        firstly(execute: {
            self.networking.fetchUserData(token: authenticationToken)
        }).done({ [weak self] user in
            guard let self = self else { return }
            
            self.user = user
        }).catch({ [weak self] error in
            guard let networkingError = error as? NetworkingError, case .serviceError(let status) = networkingError else {
                self?.handleError(error)
                return
            }
            switch status {
            case .unauthorized: AppDelegate.shared.handleSessionExpired()
            default: self?.handleError(networkingError)
            }
        }).finally {
            self.stopAnimating()
        }
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
            let myInformationViewController = self.container.resolve(MyInformationViewController.self)!
            self.navigationController?.pushViewController(myInformationViewController, animated: true)
        } else if indexPath.section == 1 {
            let medicalDocumentsViewController = self.container.resolve(MedicalDocumentsViewController.self)!
            self.navigationController?.pushViewController(medicalDocumentsViewController, animated: true)
        } else {
            let logHistoryViewController = self.container.resolve(LogHistoryViewController.self)!
            self.navigationController?.pushViewController(logHistoryViewController, animated: true)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
