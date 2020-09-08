//
//  FailureMockRepository.swift
//  CorrenceTests
//
//  Created by hikinit on 08/09/20.
//

import Foundation

class FailureMockRateRepository: RateRepository {
  var error: Error

  init(error: Error) {
    self.error = error
  }

  override func fetch(base: String, completion: @escaping (Result<Currency, Error>) -> Void) {
    completion(.failure(RequestableError.clientError))
  }
}
