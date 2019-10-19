//
//  Errors.swift
//  Servee
//
//  Created by Levente Dimény on 2019. 05. 27..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case serviceError(HTTPStatusCode)
}
