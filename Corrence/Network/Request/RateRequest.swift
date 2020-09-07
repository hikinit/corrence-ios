//
//  RateRequest.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

struct RateRequest: Requestable, JSONRequestable {
  typealias ResponseType = Currency
  var url: URL

  init(endpoint: Endpoint) {
    self.url = endpoint.fullURL
  }
}
