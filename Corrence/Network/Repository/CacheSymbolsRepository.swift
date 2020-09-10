//
//  CacheSymbolsRepository.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import Foundation

struct CacheSymbolsRepository: SymbolRepositoryType {
  func fetch(completion: @escaping CompletionHandler) {
    guard let cached = cachedData else {
      completion(.failure(CacheableError.cacheNotFound))
      return
    }

    completion(.success(cached))
  }
}

extension CacheSymbolsRepository: Cacheable {
  var cachedData: Symbols? {
    guard let data = UserDefaults.standard.object(forKey: cacheKey) as? Data else {
      return nil
    }
    return try? PropertyListDecoder().decode(Symbols.self, from: data)
  }

  func cache(data: Symbols) {
    let data = try? PropertyListEncoder().encode(data)
    UserDefaults.standard.setValue(data, forKey: cacheKey)
  }

  func removeCache() {
    UserDefaults.standard.removeObject(forKey: cacheKey)
  }
}
