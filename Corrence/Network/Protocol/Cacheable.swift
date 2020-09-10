//
//  Cacheable.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import Foundation

protocol Cacheable {
  associatedtype Cache: Codable

  var cacheKey: String { get }
  var cachedData: Cache? { get }

  func cache(data: Cache)
  func removeCache()
}

extension Cacheable {
  var cacheKey: String {
    String(describing: Self.self)
  }
}

enum CacheableError: Error {
  case cacheNotFound
}
