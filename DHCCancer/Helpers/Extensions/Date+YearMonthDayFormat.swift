//
//  Date+FormatToYearMonthDayString.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 06. 05..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation

extension Date {
    func yearMonthDayFormat() -> String {
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        let formattedDate = format.string(from: self)
        return formattedDate
    }
}
