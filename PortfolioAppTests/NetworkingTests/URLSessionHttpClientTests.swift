//
//  URLSessionHttpClientTests.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import XCTest
@testable import PortfolioApp

final class URLSessionHttpClientTests: XCTestCase {
    
    override func tearDown() async throws {
        MockURL.mockResponseData = nil
        MockURL.mockHttpResponse = nil
        MockURL.mockResponseError = nil
    }
    
    // MARK: - Tests
    
    func testFetchData_successResponse() async throws {
        let mockData = "Data".data(using: .utf8)!
        let mockService = MockService()
        let mockHttpResponse = HTTPURLResponse(url: try mockService.buildURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURL.mockResponseData = mockData
        MockURL.mockHttpResponse = mockHttpResponse
        let httpClient = URLSessionHttpClient(urlSession: makeMockSession())
        let data = try await httpClient.fetchData(from: mockService)
        XCTAssertEqual(data, mockData)
    }
    
    func testFetchData_errorResponse() async throws {
        let mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        MockURL.mockResponseError = mockError
        let httpClient = URLSessionHttpClient(urlSession: makeMockSession())
        do {
            _ = try await httpClient.fetchData(from: MockService())
            XCTFail("No error thrown")
        } catch {
            XCTAssertEqual((error as NSError).domain, "TestError")
        }
    }
    
    // MARK: - Helper methods
    
    private func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURL.self]
        return URLSession(configuration: config)
    }
}
