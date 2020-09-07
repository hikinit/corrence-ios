//
//  Currency.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

struct Currency {
  typealias ISO = String
  typealias Value = Float
  typealias Rates = [ISO: Value]

  var base: ISO
  var rates: Rates
}

extension Currency: Decodable {}
