//
//  MyInformationViewController.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject
import PromiseKit
import NVActivityIndicatorView

class MyInformationViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var tableView: UITableView!
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    private let container: Container
    
    private var tableHeaderView = MyInformationHeaderView()
    
    var user: User?
    
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
        
        self.title = "My information"

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: String(describing: MyInformationTableViewCell.self), bundle: nil), forCellReuseIdentifier: MyInformationTableViewCell.reuseIdentifier)
        
        self.fetchProfileDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setUpTableHeaderView()
    }
    
    private func fetchProfileDetails() {
        guard let authenticationToken = self.currentUserProvider.authenticationToken else { return }
        self.startAnimating()
        
        firstly(execute: {
            self.networking.fetchUserData(token: authenticationToken)
        }).done({ [weak self] user in
            guard let self = self else { return }
            
            self.user = user
            self.tableView.reloadData()
        }).catch({ [weak self] error in
            guard let networkingError = error as? NetworkingError, case .serviceError(let status) = networkingError else {
                self?.handleError(error)
                return
            }
            switch status {
            case .unauthorized: self?.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Bad email or password", comment: ""))
            default: self?.handleError(networkingError)
            }
        }).finally {
            self.stopAnimating()
        }
    }
    
    private func setUpTableHeaderView() {
        tableView.layoutIfNeeded()
        
        tableHeaderView = Bundle.main.loadNibNamed(String(describing: MyInformationHeaderView.self), owner: nil, options: nil)?.first as! MyInformationHeaderView
        tableHeaderView.frame.size = CGSize(width: view.bounds.width, height: MyInformationHeaderView.height)
        self.tableView.tableHeaderView = tableHeaderView
    }
}

extension MyInformationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyInformationTableViewCell.reuseIdentifier, for: indexPath) as! MyInformationTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Full name"
            cell.detailTextLabel?.text = user?.fullname
        case 1:
            cell.textLabel?.text = "Nickname"
            cell.detailTextLabel?.text = user?.username
        case 2:
            cell.textLabel?.text = "Age"
            cell.detailTextLabel?.text = "25"
        case 3:
            cell.textLabel?.text = "Gender"
            cell.detailTextLabel?.text = user?.gender
        case 4:
            cell.textLabel?.text = "Cancer type"
            cell.detailTextLabel?.text = user?.typeOfCancer
        case 5:
            cell.textLabel?.text = "Current stage"
            cell.detailTextLabel?.text = user?.currentStage
        default:
            break
        }
        
        return cell
    }
}
