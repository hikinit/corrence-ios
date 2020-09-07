//
//  CurrencyTests.swift
//  CorrenceTests
//
//  Created by hikinit on 06/09/20.
//

import XCTest

class CurrencyTests: XCTestCase {
  func testDecodeFromJson() {
    guard let jsonPath = Bundle(for: type(of: self)).path(forResource: "rates", ofType: "json") else {
      XCTFail("Error rates.json not found")
      return
    }

    do {
      let jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
      let currency = try JSONDecoder().decode(Currency.self, from: jsonData)

      XCTAssertEqual(currency.base, "USD")
      XCTAssertNotNil(currency.rates)
    } catch {
      XCTAssert(false, error.localizedDescription)
    }
  }
}
