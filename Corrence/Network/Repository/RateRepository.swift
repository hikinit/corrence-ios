//
//  RateRepository.swift
//  Corrence
//
//  Created by hikinit on 07/09/20.
//

import Foundation

protocol RateRepositoryType {
  typealias CompletionHandler = (Result<Currency, Error>) -> Void
  func fetch(base: String, completion: @escaping CompletionHandler)
}

struct RateRepository: RateRepositoryType {
  func fetch(base: String, completion: @escaping CompletionHandler) {
    let endpoint = APIEndpoint.latest(base: base)
    let request = JSONRequest<Currency>(endpoint: endpoint)

    request.load(completion: completion)
  }
}
