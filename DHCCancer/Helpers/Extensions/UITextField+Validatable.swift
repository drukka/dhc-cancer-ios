//
//  UITextField+Validatable.swift
//  Servee
//
//  Created by Németh Barna on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import UIKit

extension UITextField: Validatable {
    var stringToValidate: String? {
        return self.text
    }
    
    func setValid(_ isValid: Bool) {
        return
    }
}
