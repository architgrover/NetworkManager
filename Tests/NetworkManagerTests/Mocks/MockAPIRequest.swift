//
//  MockAPIRequest.swift
//  NetworkManager
//
//  Created by Bharat Grover on 15/02/25.
//

import Foundation
@testable import NetworkManager

struct MockAPIRequest: APIRequest {
    typealias Response = MockAPIResponse
    
    var url: URL
    var method: HTTPMethod
    var body: Data?
    var headers: [String: String]
    
    init(url: URL, method: HTTPMethod = .GET, body: Data? = nil, headers: [String: String] = [:]) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
    }
}
