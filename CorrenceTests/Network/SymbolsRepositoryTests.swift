//
//  SymbolRepositoryTests.swift
//  CorrenceTests
//
//  Created by hikinit on 10/09/20.
//

import XCTest

class SymbolsRepositoryTests: XCTestCase {
  var sut: SymbolsRepository!

  override func setUp() {
    super.setUp()
    sut = SymbolsRepository(
      cacheRepository: CacheSymbolsRepository(),
      externalRepository: ExternalSymbolsRepository())
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testFetch() {
    let expectation = self.expectation(description: "Fetch rate")

    sut.fetch{ result in
      switch result {
      case .success(let symbols):
        XCTAssertNotEqual(symbols.list.count, 0)
        XCTAssertEqual(symbols.list["AUD"]?.code, "AUD")
      case .failure(let error):
        XCTAssert(false, error.localizedDescription)
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 2.0)
  }

}
