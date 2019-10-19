//
//  SecondOnboardingViewController.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class SecondOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private let onboardingPageViewController: OnboardingPageViewController
    
    @IBOutlet private weak var birthdateButton: UIButton!
    @IBOutlet private weak var genderButton: UIButton!
    @IBOutlet private weak var heightButton: UIButton!
    @IBOutlet private weak var weightButton: UIButton!
    
    private let birthdateTextField: UITextField = UITextField()
    private let genderTextField: UITextField = UITextField()
    private let heightTextField: UITextField = UITextField()
    private let weightTextField: UITextField = UITextField()
    
    private let genderPickerView: UIPickerView = UIPickerView()
    
    private let possibleGenders: [Gender] = [.male, .female, .other]
    
    private var currentBirthdate: Date? {
        didSet {
            guard let date = self.currentBirthdate else {
                self.birthdateButton.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
                return
            }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            self.birthdateButton.setTitle(formatter.string(from: date), for: .normal)
        }
    }
    private var currentGender: Gender? {
        didSet {
            guard let gender = self.currentGender else {
                self.genderButton.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
                return
            }
            self.genderButton.setTitle(gender.rawValue, for: .normal)
        }
    }
    private var currentHeight: Int? {
        didSet {
            guard let height = self.currentHeight else {
                self.heightButton.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
                return
            }
            self.heightButton.setTitle("\(height) cm", for: .normal)
        }
    }
    private var currentWeight: Double?
    
    // MARK: - Initialization
    
        init(onboardingPageViewController: OnboardingPageViewController) {
        self.onboardingPageViewController = onboardingPageViewController
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
        self.birthdateTextField.frame = CGRect.zero
        self.genderTextField.frame = CGRect.zero
        self.heightTextField.frame = CGRect.zero
        self.weightTextField.frame = CGRect.zero
        
        self.view.addSubview(self.birthdateTextField)
        self.view.addSubview(self.genderTextField)
        self.view.addSubview(self.heightTextField)
        self.view.addSubview(self.weightTextField)
    }
    
    private func setupInputs() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        toolbar.tintColor = UIColor(named: "Hibiscus")
        
        let birthdateDatePicker = UIDatePicker()
        birthdateDatePicker.datePickerMode = .date
        birthdateDatePicker.maximumDate = Date()
        birthdateDatePicker.date = self.currentBirthdate ?? Date()
        birthdateDatePicker.addTarget(self, action: #selector(birthdateDatePickerValueChanged(_:)), for: .valueChanged)
        self.birthdateTextField.inputView = birthdateDatePicker
        self.birthdateTextField.inputAccessoryView = toolbar
        
        self.genderPickerView.dataSource = self
        self.genderPickerView.delegate = self
        self.genderTextField.inputView = self.genderPickerView
        self.genderTextField.inputAccessoryView = toolbar
        
        self.heightTextField.keyboardType = .decimalPad
        self.heightTextField.inputAccessoryView = toolbar
        self.heightTextField.addTarget(self, action: #selector(heightTextFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - Control events
    
    @IBAction private func selectionButtonTapped(_ sender: UIButton) {
        switch sender {
        case self.birthdateButton:
            self.birthdateTextField.becomeFirstResponder()
        case self.genderButton:
            self.genderTextField.becomeFirstResponder()
        case self.heightButton:
            self.heightTextField.becomeFirstResponder()
        case self.weightButton:
            self.weightTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    @objc private func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.birthdateTextField.resignFirstResponder()
        self.genderTextField.resignFirstResponder()
        self.heightTextField.resignFirstResponder()
        self.weightTextField.resignFirstResponder()
    }
    
    @objc private func birthdateDatePickerValueChanged(_ sender: UIDatePicker) {
        self.currentBirthdate = sender.date
    }
    
    @objc private func heightTextFieldEditingChanged(_ sender: UITextField) {
        guard let height = Int(sender.text ?? "0") else { return }
        self.currentHeight = height
    }
}

// MARK: - Picker view data source and delegate

extension SecondOnboardingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.genderPickerView: return self.possibleGenders.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.genderPickerView: return possibleGenders[row].rawValue
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.genderPickerView: self.currentGender = self.possibleGenders[row]
        default: break
        }
    }
}
