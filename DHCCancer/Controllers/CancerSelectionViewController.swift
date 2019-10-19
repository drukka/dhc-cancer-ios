//
//  CancerSelectionViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class CancerSelectionViewController: UITableViewController {

    // MARK: - Properties
    
    var delegate: CancerSelectionViewControllerDelegate?
    
    private var doneButton: UIBarButtonItem!
    private let searchController = UISearchController()
    
    private var cancers = [String]()
    private var filteredCancers = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var selectedCancer: String? {
        didSet {
            self.doneButton.isEnabled = self.selectedCancer != nil
        }
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Select cancer", comment: "")
        self.setupTableView()
        self.setupNavigationBar()
        self.setupBackground()
        self.setupNavigationItem()
        self.loadCancers()
        self.setupSearchController()
        self.selectedCancer = nil
    }

    // MARK: - Private methods
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "CancerCell", bundle: nil), forCellReuseIdentifier: "CancerCell")
    }
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(image: UIImage(named: "BackgroundImage"))
        backgroundImageView.frame = self.view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = backgroundImageView
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "SweetCorn")
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func setupNavigationItem() {
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = self.doneButton
    }
    
    private func loadCancers() {
        if let path = Bundle.main.path(forResource: "Cancers", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.cancers = try JSONDecoder().decode([String].self, from: data)
                self.filteredCancers = cancers
            } catch {
                print("reading error")
            }
        }
    }
    
    private func setupSearchController() {
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.titleView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCancers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CancerCell", for: indexPath) as? CancerCell else { fatalError() }
        cell.cancer = self.filteredCancers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCancer = self.filteredCancers[indexPath.row]
    }
    
    // MARK: - Control events
    
    @objc private func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.searchController.isActive = false
        if let cancer = self.selectedCancer {
            self.delegate?.cancerSelectionViewController(self, didSelectCancer: cancer)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - UISearchResultUpdating methods

extension CancerSelectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text, keyword != "" else {
            self.filteredCancers = cancers
            return
        }
        self.filteredCancers = self.cancers.filter({ $0.range(of: keyword, options: [.caseInsensitive], range: nil, locale: nil) != nil })
    }
}

protocol CancerSelectionViewControllerDelegate {
    func cancerSelectionViewController(_ viewController: CancerSelectionViewController, didSelectCancer cancer: String)
}
