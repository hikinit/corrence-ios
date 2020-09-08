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
      XCTAssertEqual(sut.title, "\(base) Latest Rates")
      XCTAssertEqual(sut.currencyBase, base)
      XCTAssertEqual(sut.currencyRates.count, 5)

      expectation.fulfill()
    }

    sut.input.viewDidLoad()
    base = "EUR"
    sut.input.selectBase(base)

    wait(for: [expectation], timeout: 1.0)
  }

  func testFetchCurrencyFail() {
    let expectation = XCTestExpectation()
    sut = RateViewModel(repository: FailureMockRateRepository())


    sut.output.onError = { error in
      XCTAssertEqual(error.localizedDescription, RequestableError.clientError.localizedDescription)
      expectation.fulfill()
    }

    sut.input.viewDidLoad()

    wait(for: [expectation], timeout: 1.0)
  }
}

// MARK: - Mock Helper Class
fileprivate class MockRateRepository: RateRepository {
  override init() {
    super.init()
  }

  override func fetch(base: String, completion: @escaping (Result<Currency, Error>) -> Void) {
    var currency = Currency(base: base, rates: [])
    currency.rates.append(CurrencyRate(iso: "EUR", value: 0.84))
    currency.rates.append(CurrencyRate(iso: "GBP", value: 0.75))
    currency.rates.append(CurrencyRate(iso: "IDR", value: 14700))
    currency.rates.append(CurrencyRate(iso: "JPY", value: 106))
    currency.rates.append(CurrencyRate(iso: "SGD", value: 1.36))

    completion(.success(currency))
  }
}

fileprivate class FailureMockRateRepository: RateRepository {
  override init() {
    super.init()
  }

  override func fetch(base: String, completion: @escaping (Result<Currency, Error>) -> Void) {
    completion(.failure(RequestableError.clientError))
  }
}
