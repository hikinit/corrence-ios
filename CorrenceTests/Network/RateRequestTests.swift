//
//  RateRequestTests.swift
//  CorrenceTests
//
//  Created by hikinit on 06/09/20.
//

import XCTest

class RateRequestTests: XCTestCase {
  var sut: RateRequest!

  override func setUp() {
    super.setUp()
    let endpoint = APIEndpoint.latest(base: "USD")
    sut = RateRequest(endpoint: endpoint)
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

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

    let json = sut.parse(data)

    guard case let .success(currency) = json else {
      return
    }

    XCTAssertEqual(currency.base, "USD")
    XCTAssertNotNil(currency.rates)
  }

  func testLoadJson() {
    let exceptation = self.expectation(description: "Load JSON")

    sut.load { result in
      switch result {
      case .success(let currency):
        XCTAssertEqual(currency.base, "USD")
        XCTAssertNotNil(currency.rates)
      case .failure(let error):
        XCTAssert(false, error.localizedDescription)
      }

      exceptation.fulfill()
    }

    wait(for: [exceptation], timeout: 2.0)
  }

  //TODO: Add mock networking
}
