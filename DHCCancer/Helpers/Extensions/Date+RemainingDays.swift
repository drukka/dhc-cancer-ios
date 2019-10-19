//
//  Date+DaysBetween.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 06. 05..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation

extension Date {    
    func remainingDays(until date: Date) -> Int? {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: self) else { return nil }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: date) else { return nil }
        return end - start
        
    }
}
