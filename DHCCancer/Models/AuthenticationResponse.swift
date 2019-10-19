//
//  AuthenticationResponse.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import Foundation

struct AuthenticationResponse: Codable {
    
    // MARK: - Properties
    
    let user: User
    let token: String
    
}
