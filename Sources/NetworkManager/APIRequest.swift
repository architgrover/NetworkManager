//
//  APIRequest.swift
//  NetworkManager
//
//  Created by Bharat Grover on 15/02/25.
//

import Foundation

public protocol APIRequest: Sendable {
    associatedtype Response: Decodable, Sendable
    var url: URL { get }
    var body: Data? { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? { get }
}

public extension APIRequest {
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        return nil
    }
}

public protocol APIResponse: Decodable, Sendable {}
