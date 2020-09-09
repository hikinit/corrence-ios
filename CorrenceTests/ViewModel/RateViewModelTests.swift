//
//  RateViewModelTests.swift
//  CorrenceTests
//
//  Created by hikinit on 07/09/20.
//

import XCTest

class RateViewModelTests: XCTestCase {
  var sut: RateViewModel!

  override func setUp() {
    super.setUp()
    sut = RateViewModel(repository: MockRateRepository())
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testFetchCurrency() {
    let expectation = XCTestExpectation()
    var base = "USD"

    sut.output.reloadData = { [self] in
      XCTAssertEqual(sut.title.value, "\(base) Latest Rates")
      XCTAssertEqual(sut.currencyBase, base)
      XCTAssertEqual(sut.numberOfItems, 6)

      expectation.fulfill()
    }

    sut.input.viewDidLoad()
    base = "EUR"
    sut.input.selectBase(base)

    wait(for: [expectation], timeout: 1.0)
  }

  func testFetchCurrencyFail() {
    let expectation = XCTestExpectation()
    let customError = RequestableError.clientError
    sut = RateViewModel(repository: FailureMockRateRepository(error:customError))

    sut.output.onError = { error in
      XCTAssertEqual(error.localizedDescription, customError.localizedDescription)
      expectation.fulfill()
    }

    sut.input.viewDidLoad()

    wait(for: [expectation], timeout: 1.0)
  }

  func testCurrencyRateCellModel() {
    sut.input.viewDidLoad()

    var indexPath = IndexPath(row: 1, section: 0)
    sut.input.selectItemAtIndexPath(indexPath)

    var sut = self.sut.output.selectedItemModel

    XCTAssertEqual(sut.output.currencyIsoCode, "EUR")
    XCTAssertEqual(sut.output.currencyValue, "0.849407")
    XCTAssertEqual(sut.output.currencySymbol, "€")

    indexPath = IndexPath(row: 0, section: 0)
    self.sut.input.selectItemAtIndexPath(indexPath)
    sut = self.sut.output.selectedItemModel

    XCTAssertEqual(sut.output.currencyIsoCode, "BTC")
    XCTAssertEqual(sut.output.currencyValue, "0.000099")
    XCTAssertEqual(sut.output.currencySymbol, "BTC")
  }
}

