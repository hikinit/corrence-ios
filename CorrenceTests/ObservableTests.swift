//
//  ObservableTests.swift
//  CorrenceTests
//
//  Created by hikinit on 06/09/20.
//

import XCTest

class ObservableTests: XCTestCase {
  func testObservable() {
    let expectation = XCTestExpectation()
    let sut = Observable(100)
    var observedValue = 0

    let observer = sut.bind { value in
      observedValue = value

      XCTAssertEqual(sut.value, observedValue)
      expectation.fulfill()
    }

    sut.unbind(observer)
    sut.value = 50

    XCTAssertNotEqual(sut.value, observedValue)

    wait(for: [expectation], timeout: 1)
  }
}
