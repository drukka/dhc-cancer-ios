//
//  Networking.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import Foundation
import PromiseKit

protocol Networking {
    func logIn(email: String, password: String) -> Promise<AuthenticationResponse>
    func signUp(email: String, password: String) -> Promise<AuthenticationResponse>
    func updateUserData(request: UpdateUserRequest, token: String) -> Promise<Void?>
    func fetchUserData(token: String) -> Promise<User>
    func fetchEntries(token: String) -> Promise<[Entry]>
    func logTemperature(value: Double, token: String) -> Promise<Void?>
    func logWeight(value: Int, token: String) -> Promise<Void?>
}
