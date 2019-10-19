//
//  UserDefaults+IsFirstLaunch.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 05. 30..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    var isFirstLaunch: Bool {
        get {
            return !self.bool(forKey: "isFirstLaunch")
        }
        set {
            self.set(!newValue, forKey: "isFirstLaunch")
        }
    }
}
