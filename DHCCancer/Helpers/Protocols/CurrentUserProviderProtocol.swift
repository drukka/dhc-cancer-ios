//
//  CurrentUserProviderProtocol.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import Foundation

protocol CurrentUserProviderProtocol {
    var authenticationToken: String? { get }
    var userData: User? { get }
    func save(with user: User, authenticationToken: String)
    func destroy()
    func update(with user: User)
}
