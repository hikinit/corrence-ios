//
//  SymbolPickerViewModelTests.swift
//  CorrenceTests
//
//  Created by hikinit on 11/09/20.
//

import XCTest

class SymbolPickerViewModelTests: XCTestCase {
  var sut: SymbolPickerViewModelType!

  override func setUp() {
    super.setUp()
    sut = SymbolPickerViewModel(repository: MockSymbolRepository())
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testFetchSymbols() {
    let expectation = XCTestExpectation()

    sut.output.reloadData = { [self] in
      XCTAssertEqual(sut.output.numberOfItems, 4)

      expectation.fulfill()
    }

    sut.input.viewDidLoad()

    wait(for: [expectation], timeout: 1.0)
  }

  func testFetchCurrencyFail() {
    let expectation = XCTestExpectation()
    let customError = RequestableError.unknownError
    sut = SymbolPickerViewModel(repository: FailureMockSymbolRepository(error: customError))

    sut.output.onError = { error in
      XCTAssertEqual(error.localizedDescription, customError.localizedDescription)
      expectation.fulfill()
    }

    sut.input.viewDidLoad()

    wait(for: [expectation], timeout: 1.0)
  }

  func testSymbolModel() {
    sut.input.viewDidLoad()

    let indexPath = IndexPath(row: 0, section: 0)
    sut.input.selectItemAtIndexPath(indexPath)

    let aud = sut.output.selectedItemModel
    XCTAssertEqual(aud.output.symbolCode, "AUD")
    XCTAssertEqual(aud.output.symbolDescription, "Australian Dollar")
  }
}
