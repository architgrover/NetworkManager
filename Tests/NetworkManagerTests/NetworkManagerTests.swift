import XCTest
import Foundation
@testable import NetworkManager

final class NetworkManagerTests: XCTestCase {
    func testSendRequestAsyncSuccess() async throws {
        let request = MockAPIRequest(url: URL(string: "https://api.mock.com/success")!)
        let networkManager = MockNetworkManager()
        
        // Act
        do {
            let response: MockAPIResponse = try await networkManager.sendRequestAsync(request: request)
            // Assert
            XCTAssertEqual(response.message, "Success")
        } catch {
            print("Test failed with error: \(error)")
            XCTFail("Expected to succeed but failed")
        }
    }
    
    func testSendRequestAsyncFailure() async throws {
        // Arrange
        let request = MockAPIRequest(url: URL(string: "https://api.mock.com/failure")!)
        let networkManager = MockNetworkManager()
        
        do {
            // Act
            _ = try await networkManager.sendRequestAsync(request: request)
            XCTFail("Expected to throw an error but did not")
        } catch let error as NetworkError {
            // Assert
            XCTAssertEqual(error, .notFound)
        }
    }
    
    func testSendRequestAsyncUnauthorized() async throws {
        // Arrange
        let request = MockAPIRequest(url: URL(string: "https://api.mock.com/unauthorized")!)
        let networkManager = MockNetworkManager()
        
        do {
            // Act
            _ = try await networkManager.sendRequestAsync(request: request)
            XCTFail("Expected to throw an error but did not")
        } catch let error as NetworkError {
            // Assert
            XCTAssertEqual(error, .unauthorized)
        }
    }
    
    func testSendRequestAsyncForbidden() async throws {
        // Arrange
        let request = MockAPIRequest(url: URL(string: "https://api.mock.com/forbidden")!)
        let networkManager = MockNetworkManager()
        
        do {
            // Act
            _ = try await networkManager.sendRequestAsync(request: request)
            XCTFail("Expected to throw an error but did not")
        } catch let error as NetworkError {
            // Assert
            XCTAssertEqual(error, .forbidden)
        }
    }
    
    func testSendRequestAsyncCustomError() async throws {
        // Arrange
        let request = MockAPIRequest(url: URL(string: "https://api.mock.com/customError")!)
        let networkManager = MockNetworkManager()
        
        do {
            // Act
            _ = try await networkManager.sendRequestAsync(request: request)
            XCTFail("Expected to throw an error but did not")
        } catch let error as NetworkError {
            // Assert
            switch error {
            case .custom(let code, let message):
                XCTAssertEqual(code, 400)
                XCTAssertEqual(message, "Custom error message")
            default:
                XCTFail("Expected custom error but got \(error)")
            }
        }
    }
}
