//
//  RateRequest.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

class RateRequest: Requestable {
  var url: URL

  enum RateRequestError: Error {
    case cannotDecodeJSON
  }

  init(endpoint: Endpoint) {
    self.url = endpoint.fullURL
  }

  func parse(_ data: Data) -> Result<Currency, Error> {
    do {
      let currency = try JSONDecoder().decode(Currency.self, from: data)
      return .success(currency)
    } catch {
      return .failure(RateRequestError.cannotDecodeJSON)
    }
  }
}
