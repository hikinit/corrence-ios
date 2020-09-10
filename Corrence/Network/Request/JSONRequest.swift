//
//  RateRequest.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

struct JSONRequest<T>: Requestable, JSONRequestable where T: Decodable {
  typealias ResponseType = T
  var url: URL

  init(endpoint: Endpoint) {
    self.url = endpoint.fullURL
  }
}
