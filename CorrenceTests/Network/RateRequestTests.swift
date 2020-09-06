//
//  RateRequestTests.swift
//  CorrenceTests
//
//  Created by hikinit on 06/09/20.
//

import XCTest

class RateRequestTests: XCTestCase {
  func getData() -> Data? {
    guard let jsonPath = Bundle(for: type(of: self)).path(forResource: "rates", ofType: "json") else {
      fatalError("Error rates.json not found")
    }

    do {
      return try Data(contentsOf: URL(fileURLWithPath: jsonPath))
    } catch {
      return nil
    }
  }

  func testParsingJson() {
    guard let data = getData() else {
      XCTFail("No data found")
      return
    }

    let endpoint = APIEndpoint.latest(base: "USD")
    let sut = RateRequest(endpoint: endpoint)

    let json = sut.parse(data)

    guard case let .success(currency) = json else {
      return
    }

    XCTAssertEqual(currency.base, "USD")
    XCTAssertNotNil(currency.rates)
  }
}
