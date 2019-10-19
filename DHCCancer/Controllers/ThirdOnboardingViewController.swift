//
//  ThirdOnboardingViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit
import Swinject

final class ThirdOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private let onboardingPageViewController: OnboardingPageViewController
    private let container: Container
    
    @IBOutlet private weak var cancerTypeButton: UIButton!
    @IBOutlet private weak var stageButton: UIButton!
    
    private let possibleStages: [String] = [
        "Stage 1",
        "Stage 2",
        "Stage 3",
        "Stage 4"
    ]
    
    private var currentStage: String? {
        didSet {
            guard let stage = self.currentStage else {
                self.stageButton.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
                return
            }
            self.stageButton.setTitle(stage, for: .normal)
        }
    }
    private var currentCancer: String? {
        didSet {
            guard let cancer = self.currentCancer else {
                self.cancerTypeButton.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
                return
            }
            self.cancerTypeButton.setTitle(cancer, for: .normal)
        }
    }
    
    private let stageTextField: UITextField = UITextField()
    
    private let stagePickerView = UIPickerView()
    
    
    // MARK: - Initialization
    
    init(onboardingPageViewController: OnboardingPageViewController, container: Container) {
        self.onboardingPageViewController = onboardingPageViewController
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        self.setupInputs()
    }
    
    // MARK: - Private methods
    
    private func setupTextFields() {
        self.stageTextField.frame = self.stageButton.superview!.convert(self.stageButton.frame, to: self.view)
        
        self.stageTextField.isHidden = true
        
        self.view.addSubview(self.stageTextField)
    }
    
    private func setupInputs() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        toolbar.tintColor = UIColor(named: "Hibiscus")
        
        self.stagePickerView.dataSource = self
        self.stagePickerView.delegate = self
        self.stageTextField.inputView = self.stagePickerView
        self.stageTextField.inputAccessoryView = toolbar
        
    }
    
    private func jumpToTheNextViewController() {
        self.onboardingPageViewController.jumpToViewControllerAt(3)
    }
    
    private func updateUpdateUserRequest() {
        self.onboardingPageViewController.updateUserRequest.typeOfCancer = self.currentCancer
        self.onboardingPageViewController.updateUserRequest.currentStage = self.currentStage
    }
    
    // MARK: - Control events
    
    @IBAction private func selectionButtonTapped(_ sender: UIButton) {
        switch sender {
        case self.cancerTypeButton:
            let cancerSelectionViewController = self.container.resolve(CancerSelectionViewController.self)!
            cancerSelectionViewController.delegate = self
            self.present(UINavigationController(rootViewController: cancerSelectionViewController), animated: true, completion: nil)
        case self.stageButton:
            self.stageTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    @objc private func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.stageTextField.resignFirstResponder()
    }
    
    @IBAction private func nextButtonTapped(_ sender: UIButton) {
        self.updateUpdateUserRequest()
        self.jumpToTheNextViewController()
    }
    
    @IBAction private func skipButtonTapped(_ sender: UIButton) {
        self.updateUpdateUserRequest()
        self.jumpToTheNextViewController()
    }
}

// MARK: - Picker view data source and delegate

extension ThirdOnboardingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.possibleStages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.possibleStages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentStage = self.possibleStages[row]
    }
}

// MARK: - CancerSelectionViewController methods

extension ThirdOnboardingViewController: CancerSelectionViewControllerDelegate {
    
    func cancerSelectionViewController(_ viewController: CancerSelectionViewController, didSelectCancer cancer: String) {
        self.currentCancer = cancer
    }
}
