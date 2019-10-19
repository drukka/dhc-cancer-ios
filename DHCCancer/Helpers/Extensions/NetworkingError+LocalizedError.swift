//
//  NetworkingError+LocalizedError.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation

extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serviceError(.unauthorized):
            return NSLocalizedString("The provided token is either invalid or has expired.", comment: "")
        default:
            return NSLocalizedString("An error has occurred. Please try again.", comment: "")
        }
    }
}
