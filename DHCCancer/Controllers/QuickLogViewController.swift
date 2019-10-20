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
    
    private var addQuickLogView: AddQuickLogView!
    private var addQuickLogViewTopConstraint: NSLayoutConstraint!
    private var isAddQuckLogViewVisible: Bool = false
    private var overlayView: UIView!
    
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
        self.setupAddQuickLogView()
        self.setupOverlayView()
        self.setupNavigationBar()
        self.setupNavigationItem()
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
    
    private func setupAddQuickLogView() {
        self.addQuickLogView = Bundle.main.loadNibNamed("AddQuickLogView", owner: nil, options: nil)?.first as? AddQuickLogView
        self.addQuickLogView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.addQuickLogView)
        
        let bottomSafeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        self.addQuickLogViewTopConstraint = self.addQuickLogView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 200)
        
        self.addQuickLogView.logDataButton.addTarget(self, action: #selector(logDataButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.addQuickLogView.heightAnchor.constraint(equalToConstant: bottomSafeAreaHeight + 300),
            addQuickLogViewTopConstraint,
            self.addQuickLogView.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        ])
    }
    
    private func showAddQuickLogView() {
        guard !self.isAddQuckLogViewVisible else { return }
        self.overlayView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.addQuickLogViewTopConstraint.constant = -200
            self.overlayView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.isAddQuckLogViewVisible = true
        })
    }
    
    private func hideAddQuickLogView() {
        guard self.isAddQuckLogViewVisible else { return }
        self.overlayView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.addQuickLogViewTopConstraint.constant = 200
            self.overlayView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.isAddQuckLogViewVisible = false
        })
    }
    
    private func setupOverlayView() {
        self.overlayView = UIView(frame: self.view.bounds)
        self.overlayView.isUserInteractionEnabled = false
        self.overlayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        self.overlayView.alpha = 0.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTapped(_:)))
        self.overlayView.addGestureRecognizer(tapGesture)
        self.view.addSubview(self.overlayView)
        self.view.bringSubviewToFront(self.addQuickLogView)
    }
    
    private func setupNavigationItem() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
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
            self.addQuickLogView.titleLabel.text = "Temperature"
            self.addQuickLogView.stepper.minimumValue = 34.0
            self.addQuickLogView.stepper.maximumValue = 45.0
            self.addQuickLogView.stepper.value = 37.0
            self.addQuickLogView.imageView.image = UIImage(named: "temp")
            self.addQuickLogView.entryType = .temperature
            self.showAddQuickLogView()
        } else if indexPath == IndexPath(item: 1, section: 0) {
            self.addQuickLogView.titleLabel.text = "Weight"
            self.addQuickLogView.stepper.minimumValue = 20.0
            self.addQuickLogView.stepper.maximumValue = 150.0
            self.addQuickLogView.stepper.value = 60.0
            self.addQuickLogView.imageView.image = UIImage(named: "weightNoBorder")
            self.addQuickLogView.entryType = .weight
            self.showAddQuickLogView()
        }
    }

    // MARK: - Control events
    
    @objc private func overlayViewDidTapped(_ sender: UIGestureRecognizer) {
        self.hideAddQuickLogView()
    }
    
    @objc private func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func logDataButtonTapped(_ sender: UIButton) {
        guard let token = self.currentUserProvider.authenticationToken else { return }
        switch self.addQuickLogView.entryType {
        case .temperature:
            self.networking.logTemperature(value: self.addQuickLogView.stepper.value, token: token).done({ [weak self] _ in
                self?.hideAddQuickLogView()
            }).cauterize()
        case .weight:
            self.networking.logWeight(value: Int(self.addQuickLogView.stepper.value), token: token).done({ [weak self] _ in
                self?.hideAddQuickLogView()
            }).cauterize()
        default: break
        }
    }

}
