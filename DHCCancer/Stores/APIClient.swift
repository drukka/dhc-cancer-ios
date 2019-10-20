//
//  APIClient.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 05. 27..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import AdSupport

final class APIClient: Networking {

    // MARK: - Properties

    private let serviceAddress: String = Bundle.main.object(forInfoDictionaryKey: "ServiceAddress") as! String
    private let deviceID: String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    private let deviceName: String = UIDevice.current.name
    private let jsonDecoder: JSONDecoder

    // MARK: - Initialization

    init() {
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        self.jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid date format"))
        })
    }

    // MARK: - Private methods

    private func decode<T: Decodable>(from data: Data, resolver: Resolver<T>) {
        if data.isEmpty {
            do {
                try resolver.fulfill(self.jsonDecoder.decode(T.self, from: "[]".data(using: .utf8)!))
                return
            } catch {
                resolver.reject(error)
                return
            }
        }

        do {
            try resolver.fulfill(self.jsonDecoder.decode(T.self, from: data))
        } catch {
            resolver.reject(error)
        }
    }

    private func getNetworkingError(forResponse response: PMKAlamofireDataResponse) -> NetworkingError {
        return NetworkingError.serviceError(HTTPStatusCode(rawValue: response.response?.statusCode ?? -1) ?? .unknown)
    }

    private func buildPromiseWithResponse<T: Decodable>(url: URLConvertible, method: HTTPMethod, successStatus: HTTPStatusCode, headers: HTTPHeaders?, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> Promise<T> {
        return Promise(resolver: {resolver in
            firstly(execute: {
                Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData()
            }).done({ [weak self] data, response in
                guard response.response?.statusCode == successStatus.rawValue || response.response?.statusCode == HTTPStatusCode.noContent.rawValue else {
                    resolver.reject(self?.getNetworkingError(forResponse: response) ?? NSError())
                    return
                }
                self?.decode(from: data, resolver: resolver)
            }).catch({error in
                resolver.reject(error)
            })
        })
    }

    private func buildPromiseWithoutResponse(url: URLConvertible, method: HTTPMethod, successStatus: HTTPStatusCode, headers: HTTPHeaders?, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> Promise<Void?> {
        return Promise(resolver: {resolver in
            firstly(execute: {
                Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData()
            }).done({ [weak self] data, response in
                guard response.response?.statusCode == successStatus.rawValue else {
                    resolver.reject(self?.getNetworkingError(forResponse: response) ?? NSError())
                    return
                }
                resolver.fulfill(nil)
            }).catch({error in
                resolver.reject(error)
            })
        })
    }

    private func createURL(withEndpoint endpoint: String) -> String {
        return "\(self.serviceAddress)\(endpoint)"
    }

    private func createHeaders(withToken token: String? = nil) -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }

    // MARK: - Public methods

    func logIn(email: String, password: String) -> Promise<AuthenticationResponse> {
        let parameters: Parameters = ["email": email, "password": password]
        return self.buildPromiseWithResponse(url: self.createURL(withEndpoint: "/auth/local"), method: .post, successStatus: .OK, headers: self.createHeaders(), parameters: parameters)
    }
    
    func signUp(email: String, password: String) -> Promise<AuthenticationResponse> {
        let parameters: Parameters = ["email": email, "password": password]
        return self.buildPromiseWithResponse(url: self.createURL(withEndpoint: "/auth/local/sign-up"), method: .post, successStatus: .created, headers: self.createHeaders(), parameters: parameters)
    }
    
    func fetchUserData(token: String) -> Promise<User> {
        let url = self.createURL(withEndpoint: "/users/me")
        return self.buildPromiseWithResponse(url: url, method: .get, successStatus: .OK, headers: self.createHeaders(withToken: token))
    }
    
    func fetchEntries(token: String) -> Promise<[Entry]> {
        let url = self.createURL(withEndpoint: "/time-entries")
        return self.buildPromiseWithResponse(url: url, method: .get, successStatus: .OK, headers: self.createHeaders(withToken: token))
    }

    func updateUserData(request: UpdateUserRequest, token: String) -> Promise<Void?> {
        let parameters: Parameters = request.parametersDictionary
        return self.buildPromiseWithoutResponse(url: self.createURL(withEndpoint: "/users/me"), method: .put, successStatus: .OK, headers: self.createHeaders(withToken: token), parameters: parameters)
    }
    
    func logTemperature(value: Double, token: String) -> Promise<Void?> {
        let parameters: Parameters = [
            "type": "temperature",
            "time": "2017-07-21T17:32:28Z",
            "temperature": value,
            "weight": 0,
            "startTime": 0,
            "length": 0,
            "awake": 0,
            "rem": 0,
            "light": 0,
            "deep": 0
        ]
        return self.buildPromiseWithoutResponse(url: self.createURL(withEndpoint: "/time-entries"), method: .post, successStatus: .created, headers: self.createHeaders(withToken: token), parameters: parameters)
    }
    
    func logWeight(value: Int, token: String) -> Promise<Void?> {
        let parameters: Parameters = [
            "type": "weight",
            "time": "2017-07-21T17:32:28Z",
            "weight": value,
            "temperature": 0,
            "startTime": 0,
            "length": 0,
            "awake": 0,
            "rem": 0,
            "light": 0,
            "deep": 0
        ]
        return self.buildPromiseWithoutResponse(url: self.createURL(withEndpoint: "/time-entries"), method: .post, successStatus: .created, headers: self.createHeaders(withToken: token), parameters: parameters)
    }
}
