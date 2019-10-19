//
//  CurrentUserProvider.swift
//  Servee
//
//  Created by Németh Barna on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation
import Locksmith

struct CurrentUserProvider: CurrentUserProviderProtocol {
    
    // MARK: - Properties
    
    private let storageID: String = "DHCCancer.Device.\(UIDevice.current.identifierForVendor!.uuidString).DefaultUser"
    
    // MARK: - CurrentUserProviderProtocol
    
    var authenticationToken: String? {
        return Locksmith.loadDataForUserAccount(userAccount: self.storageID)?["authenticationToken"] as? String
    }
    
    var userData: User? {
        get {
            guard let data = Locksmith.loadDataForUserAccount(userAccount: self.storageID) else { return nil }
            guard let userDictionary = data["userData"] as? [String: Any] else { return nil }
            let user = User(id: userDictionary["id"] as! Int, email: userDictionary["email"] as! String)
            return user
        }
    }
    
    func save(with user: User, authenticationToken: String) {
        try? Locksmith.deleteDataForUserAccount(userAccount: self.storageID)
        try? Locksmith.saveData(data: ["userData": user.parametersDictionary, "authenticationToken": authenticationToken], forUserAccount: self.storageID)
    }
    
    func destroy() {
        try? Locksmith.deleteDataForUserAccount(userAccount: self.storageID)
    }
    
    func update(with user: User) {
        let authenticationToken = Locksmith.loadDataForUserAccount(userAccount: self.storageID)?["authenticationToken"] as? String
        try? Locksmith.updateData(data: ["userData": user.parametersDictionary, "authenticationToken": authenticationToken as Any], forUserAccount: self.storageID)
    }
}
