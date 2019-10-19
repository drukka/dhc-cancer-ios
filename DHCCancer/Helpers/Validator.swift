//
//  Validator.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import UIKit

class Validator: NSObject, ValidatorProtocol {
    
    typealias ValidatableField = (Validatable, ValidationRule)
    
    // MARK: - Properties
    
    private var validatables = [ValidatableField]()
    private var invalidFields = [ValidatableField]()
    
    
    // MARK: - Initialization
    
    override init() { }
    
    // MARK: - Private methods
    
    private func validate(field: ValidatableField) -> Bool {
        switch field.1 {
        case .doubleConvertible:
            guard let doubleString = field.0.stringToValidate else { return false }
            return Double(doubleString) != nil
        case .integerConvertible:
            guard let integerString = field.0.stringToValidate else { return false }
            return Int(integerString) != nil
        case .email:
            guard let emalString = field.0.stringToValidate else { return false }
            return emalString.range(of: "[^ @]+@[^ @]+\\.[^ @]+", options: .regularExpression, range: nil, locale: nil) != nil
        case .notNilOrEmpty:
            return field.0.stringToValidate != nil && field.0.stringToValidate != ""
        case .password:
            guard let passwordString = field.0.stringToValidate else { return false }
            return passwordString.range(of: "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$", options: .regularExpression, range: nil, locale: nil) != nil
        }
    }
    
    // MARK: - Public methods
    
    func add(_ validatable: Validatable, withValidationRule validationRule: ValidationRule) {
        self.validatables.append((validatable, validationRule))
    }
    
    func validate() -> ValidationResult {
        self.invalidFields.removeAll()
        self.validatables.forEach({ [weak self] field in
            guard let strongSelf = self else { return }
            let isValid = strongSelf.validate(field: field)
            field.0.setValid(isValid)
            if !isValid {
                strongSelf.invalidFields.append(field)
            }
        })
        
        guard self.invalidFields.isEmpty else {
            return ValidationResult.invalid(self.invalidFields.first!.1)
        }
        return ValidationResult.valid
    }
}

protocol Validatable {
    var stringToValidate: String? { get }
    func setValid(_ isValid: Bool)
}
