//
//  SymbolPickerViewModel.swift
//  Corrence
//
//  Created by hikinit on 11/09/20.
//

import Foundation

// MARK: - IO Protocol
protocol SymbolPickerViewModelInput {
  func searchCurrency(_ search: String)
  func selectItemAtIndexPath(_ indexPath: IndexPath)
  func viewDidLoad()
}

protocol SymbolPickerViewModelOutput: AnyObject {
  var numberOfItems: Int { get }
  var onError: ((Error) -> Void) { get set }
  var reloadData: (() -> Void) { get set }
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
    symbols.count
  }

  var onError: ((Error) -> Void) = {_ in}
  var reloadData: (() -> Void) = {}
  var selectedItemModel: SymbolViewModelType {
    SymbolViewModel(symbol: symbols[selectedIndexPath.row])
  }

  var title: String {
    "Change currency"
  }

  // MARK: - Helper
  private var symbols: [Symbol] = []
  private func fetchSymbols() {
    repository.fetch { [weak self] in
      switch $0 {
      case .success(let symbols):
        self?.symbols = symbols.list.map { $1 }.sorted { $1.code > $0.code }
        self?.output.reloadData()
      case .failure(let error):
        self?.output.onError(error)
      }
    }
  }

  // MARK: - IO Declaration
  var input: SymbolPickerViewModelInput { self }
  var output: SymbolPickerViewModelOutput { self }
}
