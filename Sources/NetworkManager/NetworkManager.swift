// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol NetworkManagerProtocol {
    func sendRequestAsync<T: APIRequest>(request: T) async throws -> T.Response
}

public actor NetworkManager: NetworkManagerProtocol {
    public static let shared = NetworkManager()
    private init() {}
    
    public func sendRequestAsync<T: APIRequest>(request: T) async throws -> T.Response {
        let urlRequest = try buildURLRequest(from: request)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badServerResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.parseError(statusCode: httpResponse.statusCode, data: data)
        }
        
        do {
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
            print("Response Data: \(String(describing: jsonResponse))")
            let jsonDecoder = JSONDecoder()
            if let dateDecodingStrategy = request.dateDecodingStrategy {
                jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
            }
            return try jsonDecoder.decode(T.Response.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    private func buildURLRequest<T: APIRequest>(from request: T) throws -> URLRequest {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        request.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        if request.method == .POST {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = request.body
        }
        return urlRequest
    }
}
