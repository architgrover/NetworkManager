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
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        for (headerField, headerValue) in request.headers {
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        if request.method == .POST {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = request.body
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        print("Response: \(response)")
        if !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.parseError(statusCode: httpResponse.statusCode, data: data)
        }
        let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
        print("Response Data: \(String(describing: jsonResponse))")
        return try JSONDecoder().decode(T.Response.self, from: data)
    }
}
