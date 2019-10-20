//
//  QuickLogViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 20..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject
import PromiseKit

class QuickLogViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    
    private let networking: Networking
    private let currentUserProvider: CurrentUserProviderProtocol
    private let container: Container
    
    private let items: [(imageName: String, title: String)] = [
        (imageName: "temperature", title: "Temperature"),
        (imageName: "weight", title: "Weight"),
        (imageName: "sleep", title: "Sleep"),
        (imageName: "bloodPressure", title: "Blood pressure"),
        (imageName: "mood", title: "Mood"),
        (imageName: "water", title: "Water"),
        (imageName: "hairLoss", title: "Hair loss"),
        (imageName: "otherSymptoms", title: "Other symptons"),
        (imageName: "pain", title: "Pain"),
        (imageName: "meal", title: "Meal"),
        (imageName: "medication", title: "Medication"),
        (imageName: "appointment", title: "Appointment")
    ]
    
    // MARK: - Initialization
    
    init(networking: Networking, currentUserProvider: CurrentUserProviderProtocol, container: Container) {
        self.networking = networking
        self.currentUserProvider = currentUserProvider
        self.container = container
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.setupNavigationBar()
        self.setupCollectionView()
        self.title = NSLocalizedString("Quick log", comment: "")
    }

    // MARK: - Private methods
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(image: UIImage(named: "BackgroundImage"))
        backgroundImageView.frame = self.view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        self.collectionView.backgroundView = backgroundImageView
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupCollectionView() {
        self.collectionView.register(UINib(nibName: "QuickLogCell", bundle: nil), forCellWithReuseIdentifier: "QuickLogCell")
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickLogCell", for: indexPath) as? QuickLogCell else { fatalError() }
        cell.imageView.image = UIImage(named: self.items[indexPath.row].imageName)
        cell.label.text = self.items[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 3
        return CGSize(width: cellWidth, height: 145.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == IndexPath(item: 0, section: 0) {
            print("temp")
        } else if indexPath == IndexPath(item: 1, section: 0) {
            print("weight")
        }
    }


}
