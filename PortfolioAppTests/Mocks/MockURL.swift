//
//  MockURL.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import Foundation

final class MockURL: URLProtocol {
    
    static var mockResponseData: Data?
    static var mockResponseError: Error?
    static var mockHttpResponse: HTTPURLResponse?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURL.mockResponseError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            let response = MockURL.mockHttpResponse ?? HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = MockURL.mockResponseData {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
