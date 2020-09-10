//
//  SymbolsRepository.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import Foundation

protocol SymbolRepositoryType {
  typealias CompletionHandler = (Result<Symbols, Error>) -> Void
  func fetch(completion: @escaping CompletionHandler)
}

struct SymbolsRepository: SymbolRepositoryType {
  let cacheRepository: CacheSymbolsRepository
  let externalRepository: ExternalSymbolsRepository

  func fetch(completion: @escaping CompletionHandler) {
    cacheRepository.fetch { cache in
      guard case let .success(cachedSymbols) = cache else {
        loadExternaly(completion: completion)
        return
      }

      completion(.success(cachedSymbols))
    }
  }

  private func loadExternaly(completion: @escaping CompletionHandler) {
    externalRepository.fetch { result in
      switch result {
      case .success(let symbols):
        cacheRepository.cache(data: symbols)
        completion(.success(symbols))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
