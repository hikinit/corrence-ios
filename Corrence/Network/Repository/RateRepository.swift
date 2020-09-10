//
//  RateRepository.swift
//  Corrence
//
//  Created by hikinit on 07/09/20.
//

import Foundation

class RateRepository {
  func fetch(base: String, completion: @escaping (Result<Currency, Error>) -> Void) {
    let endpoint = APIEndpoint.latest(base: base)
    let request = JSONRequest<Currency>(endpoint: endpoint)

    request.load { result in
      completion(result)
    }
  }
}
