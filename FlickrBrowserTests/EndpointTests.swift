//
//  EndpointTests.swift
//  FlickrBrowserTests
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import XCTest
@testable import FlickrBrowser

final class EndpointTests: XCTestCase {

    func test_url_deliverValidURLWithValidBaseURLComponentsAndEmptyURLQueryItems() {
        let sut = Endpoint(queryItems: [])
        let baseURLComponents = BaseURLComponents(scheme: "http",
                                                  host: "some-url.com",
                                                  path: "/some-path")
        let expectedURL = URL(string: "http://some-url.com/some-path?")!
        
        let url = sut.url(baseURLComponents: baseURLComponents)
        
        guard let url = url else {
            XCTFail("Expected url to be non-nil")
            return
        }
        
        XCTAssertEqual(url, expectedURL, "Expected url to be equal to \(expectedURL) but got \(url) instead")
    }
    
    func test_url_deliverValidURLWithValidBaseURLComponentsAndNonEmptyURLQueryItems() {
        let sut = Endpoint(queryItems: [
            URLQueryItem(name: "p1", value: "v1"),
            URLQueryItem(name: "p2", value: "v2")
        ])
        let baseURLComponents = BaseURLComponents(scheme: "http",
                                                  host: "some-url.com",
                                                  path: "/some-path")
        let expectedURL = URL(string: "http://some-url.com/some-path?p1=v1&p2=v2")!
        
        let url = sut.url(baseURLComponents: baseURLComponents)
        
        guard let url = url else {
            XCTFail("Expected url to be non-nil")
            return
        }
        
        XCTAssertEqual(url, expectedURL, "Expected url to be equal to \(expectedURL) but got \(url) instead")
    }
}
