//
//  RateRepositoryTests.swift
//  CorrenceTests
//
//  Created by hikinit on 07/09/20.
//

import XCTest

class RateRepositoryTests: XCTestCase {
  var sut: RateRepository!

  override func setUp() {
    super.setUp()
    sut = RateRepository()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testFetch() {
    let expectation = self.expectation(description: "Fetch rate")

    sut.fetch(base: "USD") { result in
      switch result {
      case .success(let currency):
        XCTAssertEqual(currency.base, "USD")
      case .failure(let error):
        XCTAssert(false, error.localizedDescription)
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 2.0)
  }

}
