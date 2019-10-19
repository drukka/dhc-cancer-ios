//
//  User.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import Foundation

struct User: Codable {
    
    // MARK: - Properties
    
    let id: Int
    let email: String
    var fullname: String?
    var username: String?
    var typeOfCancer: String?
    var currentStage: String?
    var birthdate: Date?
    var gender: String?
    var anonymousShare: Bool?    
}
