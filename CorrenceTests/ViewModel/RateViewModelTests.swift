//
//  RateViewModelTests.swift
//  CorrenceTests
//
//  Created by hikinit on 07/09/20.
//

import XCTest

class RateViewModelTests: XCTestCase {
  var sut: RateViewModelType!

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
      XCTAssertEqual(sut.output.title.value, "\(base) Latest Rates")
      XCTAssertEqual(sut.output.numberOfItems, 6)

      expectation.fulfill()
    }

    sut.input.viewDidLoad()
    base = "EUR"
    sut.input.selectBase(base)

    wait(for: [expectation], timeout: 1.0)
  }

  func testFetchCurrencyFail() {
    let expectation = XCTestExpectation()
    let customError = RequestableError.invalidResponse
    sut = RateViewModel(repository: FailureMockRateRepository(error:customError))

    sut.output.onError = { error in
      XCTAssertEqual(error.localizedDescription, customError.localizedDescription)
      expectation.fulfill()
    }

    sut.input.viewDidLoad()

    wait(for: [expectation], timeout: 1.0)
  }

  func testSearchCurrency() {
    let expectation = XCTestExpectation()
    let indexPath = IndexPath(row: 0, section: 0)

    sut.output.reloadData = { [self] in
      sut.input.selectItemAtIndexPath(indexPath)
      let jpy = sut.output.selectedItemModel

      XCTAssertEqual(sut.output.numberOfItems, 1)
      XCTAssertEqual(jpy.output.currencyIsoCode, "JPY")

      expectation.fulfill()
    }

    sut.input.searchCurrency("jpy")

    wait(for: [expectation], timeout: 1.0)
  }

  func testCurrencyRateCellModel() {
    sut.input.viewDidLoad()

    var indexPath = IndexPath(row: 0, section: 0)
    sut.input.selectItemAtIndexPath(indexPath)

    let btc = self.sut.output.selectedItemModel

    XCTAssertEqual(btc.output.currencyIsoCode, "BTC")
    XCTAssertEqual(btc.output.currencyValue, "0.000099")
    XCTAssertEqual(btc.output.currencySymbol, "BTC")

    indexPath = IndexPath(row: 3, section: 0)
    sut.input.selectItemAtIndexPath(indexPath)
    sut.input.inputCurrencyAmount("10")
    let idr = self.sut.output.selectedItemModel

    XCTAssertEqual(idr.output.currencyIsoCode, "IDR")
    XCTAssertEqual(idr.output.currencyValue, "148,385.92")
    XCTAssertEqual(idr.output.currencySymbol, "IDR")
  }
}

