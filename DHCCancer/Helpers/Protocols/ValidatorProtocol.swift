//
//  ValidatorProtocol.swift
//  Servee
//
//  Created by Németh Barna on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation

protocol ValidatorProtocol {
    func add(_ validatable: Validatable, withValidationRule validationRule: ValidationRule)
    func validate() -> ValidationResult
}
