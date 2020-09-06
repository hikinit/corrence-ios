//
//  EndpointTests.swift
//  CorrenceTests
//
//  Created by hikinit on 06/09/20.
//

import XCTest

class EndpointTests: XCTestCase {
  func testFullURL() {
    let searchText = "Something"
    let sut = MockEndpoint.search(searchText)

    XCTAssertEqual(sut.fullURL.absoluteString, "https://example.com/search?q=Something")
  }
}

enum MockEndpoint {
  case latest
  case search(String)
}

extension MockEndpoint: Endpoint {
  var origin: String {
    "https://example.com"
  }

  var path: String {
    switch self {
    case .latest:
      return "latest"
    case .search(_):
      return "search"
    }
  }

  var parameters: [Parameter]? {
    switch self {
    case .search(let text):
      let query = Parameter(name: "q", value: text)
      return [query]
    case .latest:
      return nil
    }
  }
}
