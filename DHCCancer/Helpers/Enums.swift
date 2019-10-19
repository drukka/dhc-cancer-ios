//
//  Enums.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import UIKit

enum SizeClass {
    case threePointFiveInches //3.5
    case fourInches //4
    case fourPointSevenInches //4.7
    case fivePointFiveInches //5.5
    case fivePointEightInches //5.8
    case sixPointOneInches //6.1
    case sixPointFiveInches //6.5
    case unknown
    
    static var sizeClass: SizeClass {
        get {
            let size = UIScreen.main.bounds.size
            /* 3.5 */   if size.width == 320 && size.height == 480 { return .threePointFiveInches }
            /* 4 */     if size.width == 320 && size.height == 568 { return .fourInches }
            /* 4.7 */   if size.width == 375 && size.height == 667 { return .fourPointSevenInches }
            /* 5.5 */   if size.width == 414 && size.height == 736 { return .fivePointFiveInches }
            /* 5.8 */   if size.width == 375 && size.height == 812 { return .fivePointEightInches }
            /* 6.1 */   if size.width == 414 && size.height == 896 { return .sixPointOneInches }
            /* 6.5 */   if size.width == 414 && size.height == 896 { return .sixPointFiveInches }
            return .unknown
        }
    }
}

enum ValidationRule {
    case notNilOrEmpty
    case password
    case email
    case integerConvertible
    case doubleConvertible
}

enum ValidationResult {
    case valid
    case invalid(ValidationRule)
}

enum Gender: String {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

