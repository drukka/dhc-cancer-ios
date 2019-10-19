//
//  UpdateUserRequest.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import Foundation

struct UpdateUserRequest: Codable {
    
    // MARK: - Properties
    
    var fullname: String?
    var username: String?
    var typeOfCancer: String?
    var currentStage: String?
    var birthdate: Date?
    var gender: String?
    var anonymousShare: Bool
    var height: Int?
    var weight: Int?
    
    // MARK: - Initialization
    
    init() {
        self.fullname = nil
        self.username = nil
        self.typeOfCancer = nil
        self.currentStage = nil
        self.birthdate = nil
        self.gender = nil
        self.anonymousShare = false
        self.height = nil
        self.weight = nil
    }
}
