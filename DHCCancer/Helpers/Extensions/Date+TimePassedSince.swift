//
//  Date+TimePassedSince.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 06. 05..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation

extension Date {
    func timePassedSince() -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = (earliest == now as Date) ? self : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)

        if (components.year! >= 2) {
            return "\(components.year!)" + NSLocalizedString(" years ago", comment: "")
        } else if (components.year! >= 1){
            return NSLocalizedString("Last year", comment: "")
        } else if (components.month! >= 2) {
            return "\(components.month!)" + NSLocalizedString(" months ago", comment: "")
        } else if (components.month! >= 1){
            return NSLocalizedString("Last month", comment: "")
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)" + NSLocalizedString(" weeks ago", comment: "")
        } else if (components.weekOfYear! >= 1){
            return NSLocalizedString("Last week", comment: "")
        } else if (components.day! >= 2) {
            return "\(components.day!)" + NSLocalizedString(" days ago", comment: "")
        } else if (components.day! >= 1){
            return NSLocalizedString("Yesterday", comment: "")
        } else if (components.hour! >= 2) {
            return "\(components.hour!)" + NSLocalizedString(" hours ago", comment: "")
        } else if (components.hour! >= 1){
            return NSLocalizedString("One hour ago", comment: "")
        } else if (components.minute! >= 2) {
            return "\(components.minute!)" + NSLocalizedString(" minutes ago", comment: "")
        } else if (components.minute! >= 1){
            return NSLocalizedString("One minute ago", comment: "")
        } else if (components.second! >= 3) {
            return "\(components.second!)" + NSLocalizedString(" seconds ago", comment: "")
        } else {
            return NSLocalizedString("Just now", comment: "")
        }
    }
}
