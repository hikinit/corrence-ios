//
//  SymbolsTests.swift
//  CorrenceTests
//
//  Created by hikinit on 10/09/20.
//

import XCTest

class SymbolsTests: XCTestCase {
  func testDecodeFromJson() {
    guard let jsonPath = Bundle(for: type(of: self)).path(forResource: "symbols", ofType: "json") else {
      XCTFail("Error symbols.json not found")
      return
    }

    do {
      let jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
      let symbols = try JSONDecoder().decode(Symbols.self, from: jsonData)

      XCTAssertNotEqual(symbols.list.count, 0)
      XCTAssertEqual(symbols.list["AED"]?.code, "AED")
    } catch {
      print(error)
    }
  }
}
