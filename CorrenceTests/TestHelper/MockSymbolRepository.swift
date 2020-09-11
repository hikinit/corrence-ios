//
//  MockSymbolRepository.swift
//  CorrenceTests
//
//  Created by hikinit on 11/09/20.
//

import Foundation

struct MockSymbolRepository: SymbolRepositoryType {
  func fetch(completion: @escaping CompletionHandler) {
    let symbols = Symbols(list: [
      "AUD": Symbol(code: "AUD", description: "Australian Dollar"),
      "JPY": Symbol(code: "JPY", description: "Japanese Yen"),
      "SGD": Symbol(code: "SGD", description: "Singapore Dollar"),
      "USD": Symbol(code: "USD", description: "United States Dollar"),
    ])

    completion(.success(symbols))
  }
}

struct FailureMockSymbolRepository: SymbolRepositoryType {
  var error: Error

  init(error: Error) {
    self.error = error
  }

  func fetch(completion: @escaping CompletionHandler) {
    completion(.failure(error))
  }
}
