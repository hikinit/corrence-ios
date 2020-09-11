//
//  Filterer.swift
//  Corrence
//
//  Created by hikinit on 11/09/20.
//

import Foundation

struct CurrencyRateFilter {
  typealias Filter = ([CurrencyRate]) -> [CurrencyRate]

  var filters: [Filter]

  func filter(data: [CurrencyRate]) -> [CurrencyRate] {
    let array = filters.reduce(data) { result, filter in
      filter(result)
    }

    return array
  }
}
