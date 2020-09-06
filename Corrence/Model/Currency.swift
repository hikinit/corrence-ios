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

  var base: ISO
  var rates: [ISO: Value]
}

extension Currency: Decodable {}
