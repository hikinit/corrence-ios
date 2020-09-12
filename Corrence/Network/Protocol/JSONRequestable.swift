//
//  JSONRequestable.swift
//  Corrence
//
//  Created by hikinit on 07/09/20.
//

import Foundation

protocol JSONRequestable: Requestable where ResponseType: Decodable {
}

extension JSONRequestable {
  func parse(_ data: Data) -> ResponseResult {
    do {
      let result = try JSONDecoder().decode(ResponseType.self, from: data)
      return .success(result)
    } catch {
      return .failure(JSONRequestableError.cannotDecodeJSON)
    }
  }
}

enum JSONRequestableError: Error {
  case cannotDecodeJSON
}

extension JSONRequestableError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .cannotDecodeJSON:
      return NSLocalizedString("The data cannot be decoded to JSON", comment: "Cannot Decode JSON")
    }
  }
}
