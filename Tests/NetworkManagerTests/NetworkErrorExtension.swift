//
//  NetworkErrorExtensions.swift
//  NetworkManager
//
//  Created by Bharat Grover on 15/02/25.
//

@testable import NetworkManager

extension NetworkError: Equatable {
    public static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badServerResponse, .badServerResponse),
            (.unauthorized, .unauthorized),
            (.forbidden, .forbidden),
            (.notFound, .notFound),
            (.internalServerError, .internalServerError):
            return true
        case let (.custom(code1, message1), .custom(code2, message2)):
            return code1 == code2 && message1 == message2
        default:
            return false
        }
    }
}
