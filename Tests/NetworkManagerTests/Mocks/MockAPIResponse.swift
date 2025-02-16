//
//  MockAPIResponse.swift
//  NetworkManager
//
//  Created by Bharat Grover on 15/02/25.
//

@testable import NetworkManager

struct MockAPIResponse: APIResponse, Codable, Sendable {
    let message: String
}
