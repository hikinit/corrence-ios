//
//  ExternalSymbolsRepository.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import Foundation

struct ExternalSymbolsRepository: SymbolRepositoryType {
  func fetch(completion: @escaping CompletionHandler) {
    let endpoint = APIEndpoint.symbols
    let request = JSONRequest<Symbols>(endpoint: endpoint)

    request.load(completion: completion)
  }
}
