//
//  Filterer.swift
//  Corrence
//
//  Created by hikinit on 11/09/20.
//

import Foundation

struct Filter<T> {
  typealias Handler = ([T]) -> [T]

  var filters: [Handler]

  func filter(data: [T]) -> [T] {
    let array = filters.reduce(data) { result, filter in
      filter(result)
    }

    return array
  }
}
