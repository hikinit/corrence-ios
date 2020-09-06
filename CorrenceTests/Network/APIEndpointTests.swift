//
//  EndpointTests.swift
//  CorrenceTests
//
//  Created by hikinit on 06/09/20.
//

import XCTest

class APIEndpointTests: XCTestCase {
  func testLatestURL() {
    let base = "SGD"

    let sut = APIEndpoint.latest(base: base)
    XCTAssertEqual(sut.path, "latest")
    XCTAssertEqual(sut.parameters?.count, 1)
    XCTAssertEqual(sut.fullURL.absoluteString, "https://api.exchangerate.host/latest?base=SGD")
  }

  func testConvertURL() {
    let currencies = ("SGD", "JPY")

    let sut = APIEndpoint.convert(from: currencies.0, to: currencies.1)
    XCTAssertEqual(sut.path, "convert")
    XCTAssertEqual(sut.parameters?.count, 2)
    XCTAssertEqual(sut.fullURL.absoluteString, "https://api.exchangerate.host/convert?from=SGD&to=JPY")
  }
}

