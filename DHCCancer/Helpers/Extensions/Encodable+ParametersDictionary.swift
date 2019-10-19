//
//  Encodable+ParametersDictionary.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation
import Alamofire

extension Encodable {
    var parametersDictionary: Parameters {
        let encoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            encoder.dateEncodingStrategy = .iso8601
            return encoder
        }()
        do {
            let data = try encoder.encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return [String: Any]() }
            return dictionary
        } catch {
            return [String: Any]()
        }
    }
}
