//
//  UIDevice+HasNotch.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 06. 05..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//
import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
