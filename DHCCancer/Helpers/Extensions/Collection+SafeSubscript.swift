//
//  Collection+SafeSubscript.swift
//  Servee
//
//  Created by Németh Barna on 2019. 05. 30..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
