//
//  SymbolPickerViewModel.swift
//  Corrence
//
//  Created by hikinit on 11/09/20.
//

import Foundation

enum SymbolPickerViewModelState {
  case error(Error)
  case loading
  case loaded
}

// MARK: - IO Protocol
protocol SymbolPickerViewModelInput {
  func searchCurrency(_ search: String)
  func selectItemAtIndexPath(_ indexPath: IndexPath)
  func viewDidLoad()
}

protocol SymbolPickerViewModelOutput: AnyObject {
  var numberOfItems: Int { get }
  var onState: ((SymbolPickerViewModelState) -> Void) { get set }
  var selectedItemModel: SymbolViewModelType { get }
  var title: String { get }
}

protocol SymbolPickerViewModelType {
  var input: SymbolPickerViewModelInput { get }
  var output: SymbolPickerViewModelOutput { get }
}

// MARK: - VM
class SymbolPickerViewModel: SymbolPickerViewModelType, SymbolPickerViewModelInput, SymbolPickerViewModelOutput {
  private let repository: SymbolRepositoryType
  init(repository: SymbolRepositoryType) {
    self.repository = repository
  }

  // MARK: - Input
  private var searchText: String = ""
  func searchCurrency(_ search: String) {
    searchText = search
    fetchSymbols()
  }

  private var selectedIndexPath = IndexPath()
  func selectItemAtIndexPath(_ indexPath: IndexPath) {
    selectedIndexPath = indexPath
  }

  func viewDidLoad() {
    fetchSymbols()
  }

  // MARK: - Output
  var numberOfItems: Int {
    symbolsFiltered.count
  }

  var onState: ((SymbolPickerViewModelState) -> Void) = {_ in}
  var selectedItemModel: SymbolViewModelType {
    SymbolViewModel(symbol: symbolsFiltered[selectedIndexPath.row])
  }

  var title: String {
    "Change currency"
  }

  // MARK: - Helper
  private var symbols: [Symbol] = []
  private func fetchSymbols() {
    symbols = []
    output.onState(.loading)

    repository.fetch { [weak self] in
      switch $0 {
      case .success(let symbols):
        self?.symbols = symbols.list.map { $1 }.sorted { $1.code > $0.code }
        self?.output.onState(.loaded)
      case .failure(let error):
        self?.output.onState(.error(error))
      }
    }
  }

  // MARK: Filter
  private var symbolsFiltered: [Symbol] {
    filter.filter(data: symbols)
  }

  private var filter: Filter<Symbol>  {
    Filter(filters: [filterSearch])
  }

  private var filterSearch: Filter<Symbol>.Handler {
    return {[unowned self]  in
      guard searchText.count > 0 else { return $0 }

      return $0.filter {
        $0.code.lowercased().contains(self.searchText) ||
        $0.description.lowercased().contains(self.searchText)
      }
    }
  }

  // MARK: - IO Declaration
  var input: SymbolPickerViewModelInput { self }
  var output: SymbolPickerViewModelOutput { self }
}
