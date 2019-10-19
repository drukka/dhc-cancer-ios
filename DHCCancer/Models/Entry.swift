//
//  Entry.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

enum EntryType: String, Codable {
    case weight
    case temperature
    case sleep
    case bloodPressure
    case mood
    case water
    case hairloss
    case otherSymptoms
    case pain
    case meal
    case medication
    case appointment
}

struct Entry: Codable {
    var type: EntryType
    var time: Date?
    var weight: Int?
    var temperature: Double?
    var startTime: Int?
    var length: Int?
    var awake: Int?
    var rem: Int?
    var light: Int?
    var deep: Int?
}
