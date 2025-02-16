//
//  NetworkError.swift
//  NetworkManager
//
//  Created by Bharat Grover on 15/02/25.
//

import Foundation

public enum NetworkError: Error {
    case notFound
    case forbidden
    case unauthorized
    case badServerResponse
    case internalServerError
    case custom(code: Int, message: String)
    
    static func parseError(
        statusCode: Int,
        data: Data
    ) -> NetworkError {
        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500:
            return .internalServerError
        default:
            // Parse custom error message from the response data
            let message = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
            let errorMessage = message?["error"] as? String ?? "Unknown error"
            return .custom(code: statusCode, message: errorMessage)
        }
    }
}
