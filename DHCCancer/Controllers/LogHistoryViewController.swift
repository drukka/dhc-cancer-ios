//
//  LogHistoryViewController.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject
import PromiseKit
import NVActivityIndicatorView

class LogHistoryViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var tableView: UITableView!
    
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    private let container: Container
    
    var entries = [Entry]()
    
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
        
        self.title = "Log history"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: nil)
        
        self.tableView.register(UINib(nibName: String(describing: LogTableViewCell.self), bundle: nil), forCellReuseIdentifier: LogTableViewCell.reuseIdentifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.fetchEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func fetchEntries() {
        guard let authenticationToken = self.currentUserProvider.authenticationToken else { return }

        firstly(execute: {
            self.networking.fetchEntries(token: authenticationToken)
        }).done({ [weak self] entries in
            guard let self = self else { return }
            
            self.entries = entries
            self.tableView.reloadData()
        }).cauterize()
    }
}

extension LogHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogTableViewCell.reuseIdentifier, for: indexPath) as! LogTableViewCell
        cell.entry = entries[indexPath.row]
        return cell
    }
}
