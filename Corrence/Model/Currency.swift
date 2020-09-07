//
//  Currency.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

struct CurrencyRate {
  var iso: String
  var value: Double
}

struct Currency {
  var base: String
  var rates: [CurrencyRate]
}

extension Currency: Decodable {
  enum CodingKeys: CodingKey {
    case base
    case rates
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    base = try values.decode(String.self, forKey: .base)

    let currencyRates = try values.decode(Dictionary<String, Double>.self, forKey: .rates)
    rates = currencyRates.map { CurrencyRate(iso: $0, value: $1) }
  }
}
