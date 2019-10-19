//
//  FakeAPIClient.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 05. 27..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation
import PromiseKit

final class FakeAPIClient: Networking {
    
    private let authenticationToken = "mockToken"
    private let user = User(id: 4, email: "john.doe@mail.com", fullname: "John Doe", username: "Doe", typeOfCancer: "Breast cancer", currentStage: "2", birthdate: Date(), gender: "male", anonymousShare: true)
    private let email = "john.doe@mail.com"
    private let password = "mockPassword"
    
    // MARK: - Public methods
    
    func logIn(email: String, password: String) -> Promise<AuthenticationResponse> {
        if email == self.email && password == self.password {
            return Promise.value(AuthenticationResponse(user: self.user, token: self.authenticationToken))
        }
        
        return Promise(error: NetworkingError.serviceError(.unauthorized))
    }
    
    func updateUserData(request: UpdateUserRequest, token: String) -> Promise<Void?> {
        if token == self.authenticationToken {
            return Promise.value(nil)
        }
        return Promise(error: NetworkingError.serviceError(.unauthorized))
    }

    func signUp(email: String, password: String) -> Promise<AuthenticationResponse> {
        if email == self.email && password == self.password {
            return Promise.value(AuthenticationResponse(user: self.user, token: self.authenticationToken))
        }
        
        return Promise(error: NetworkingError.serviceError(.conflict))
    }
    
    func fetchUserData(token: String) -> Promise<User> {
        if token == authenticationToken {
            return Promise.value(self.user)
        }
        
        return Promise(error: NetworkingError.serviceError(.unauthorized))
    }
}
