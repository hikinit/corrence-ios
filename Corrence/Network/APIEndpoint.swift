//
//  APIEndpoint.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

enum APIEndpoint {
  case latest(base: String)
  case convert(from: String, to: String)
  case symbols
}

extension APIEndpoint: Endpoint {
  var origin: String {
    "https://api.exchangerate.host"
  }

  var path: String {
    switch self {
    case .latest(_):
      return "latest"
    case .convert(_, _):
      return "convert"
    case .symbols:
      return "symbols"
    }
  }

  var parameters: [Parameter]? {
    switch self {
    case .latest(let base):
      return [Parameter(name: "base", value: base)]
    case .convert(let from, let to):
      return [
        Parameter(name: "from", value: from),
        Parameter(name: "to", value: to),
      ]
    default:
      return nil
    }
  }


}
