//
//  Endpoint.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

struct Parameter {
  var name: String
  var value: String?
}

protocol Endpoint {
  var origin: String { get }
  var path: String { get }
  var parameters: [Parameter]? { get }
}

extension Endpoint {
  var fullURL: URL {
    guard var components = URLComponents(string: origin) else {
      preconditionFailure("Wrong origin format")
    }

    components.path = "/\(path)"
    components.queryItems = parameters?.map {
      URLQueryItem(name: $0.name, value: $0.value)
    }

    return components.url!
  }
}
