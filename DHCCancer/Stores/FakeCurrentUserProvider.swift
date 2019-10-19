//
//  FakeCurrentUserProvider.swift
//  Servee
//
//  Created by Németh Barna on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation

class FakeCurrentUserProvider: CurrentUserProviderProtocol {
    
    // MARK: - Properties
    
    static var userData: User? = User(id: 1, email: "mock@test.com")
    static var authenticationToken: String? = "mockToken"
    
    
    // MARK: - CurrentUserProviderProtocol methods
    
    var authenticationToken: String? {
        return FakeCurrentUserProvider.authenticationToken
    }
    
    var userData: User? {
        return FakeCurrentUserProvider.userData
    }
    
    func save(with user: User, authenticationToken: String) {
        FakeCurrentUserProvider.userData = user
        FakeCurrentUserProvider.authenticationToken = authenticationToken
    }
    
    func destroy() {
        FakeCurrentUserProvider.userData = nil
    }
    
    func update(with user: User) {
        FakeCurrentUserProvider.userData = user
    }
    
}
