//
//  Symbols.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import Foundation

struct Symbol {
  let code: String
  let description: String
}

extension Symbol: Decodable {}
extension Symbol: Equatable {}

struct Symbols {
  let list: [String: Symbol]
}

extension Symbols: Decodable {
  enum CodingKeys: String, CodingKey {
    case list = "symbols"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    list = try values.decode(Dictionary<String, Symbol>.self, forKey: .list)
  }
}
