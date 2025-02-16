//
//  HTTPMethod.swift
//  NetworkManager
//
//  Created by Bharat Grover on 15/02/25.
//

public enum HTTPMethod: String, Sendable {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
    case HEAD
    case OPTIONS
    case TRACE
    case CONNECT
}
