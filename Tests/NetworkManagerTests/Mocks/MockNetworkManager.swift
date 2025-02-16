//
//  MockNetworkManager.swift
//  NetworkManager
//
//  Created by Bharat Grover on 15/02/25.
//

import Foundation
@testable import NetworkManager

class MockNetworkManager: NetworkManagerProtocol {
    func sendRequestAsync<T: APIRequest>(request: T) async throws -> T.Response where T.Response: Sendable {
        if request.url.absoluteString.contains("success") {
            let mockResponse = MockAPIResponse(message: "Success")
            do {
                let jsonData = try JSONEncoder().encode(mockResponse)
                return try JSONDecoder().decode(T.Response.self, from: jsonData)
            } catch {
                print("Error encoding or decoding mock response: \(error)")
                throw error
            }
        }
        else if request.url.absoluteString.contains("unauthorized") {
            throw NetworkError.unauthorized
        }
        else if request.url.absoluteString.contains("forbidden") {
            throw NetworkError.forbidden
        }
        else if request.url.absoluteString.contains("customError") {
            throw NetworkError.custom(code: 400, message: "Custom error message")
        }
        else {
            throw NetworkError.notFound
        }
    }
}
