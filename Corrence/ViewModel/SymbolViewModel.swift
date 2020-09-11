//
//  SymbolViewModel.swift
//  Corrence
//
//  Created by hikinit on 11/09/20.
//

import Foundation


protocol SymbolViewModelInput {}

protocol SymbolViewModelOutput {
  var symbolCode: String { get }
  var symbolDescription: String { get }
}

protocol SymbolViewModelType {
  var output: SymbolViewModelOutput { get }
}

// MARK: - VM
class SymbolViewModel: SymbolViewModelType, SymbolViewModelOutput {
  private let symbol: Symbol
  init(symbol: Symbol) {
    self.symbol = symbol
  }

  // MARK: - Output
  var symbolCode: String {
    symbol.code
  }

  var symbolDescription: String {
    symbol.description
  }

  // MARK: - IO Declaration
  var output: SymbolViewModelOutput { self }
}

