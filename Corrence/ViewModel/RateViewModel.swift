//
//  RateViewModel.swift
//  Corrence
//
//  Created by hikinit on 07/09/20.
//

import Foundation

enum RateViewModelState {
  case error(Error)
  case loading
  case loaded
}

// MARK: - IO Protocol
protocol RateViewModelInput {
  func inputCurrencyAmount(_ amount: String)
  func searchCurrency(_ search: String)
  func selectBase(_ base: String)
  func selectItemAtIndexPath(_ indexPath: IndexPath)
  func viewDidLoad()
}

protocol RateViewModelOutput: AnyObject {
  var currencyBase: String { get set }
  var numberOfItems: Int { get }
  var onState: ((RateViewModelState) -> Void) { get set }
  var selectedItemModel: RateViewCellModelType { get }
  var title: String { get }
}

protocol RateViewModelType {
  var input: RateViewModelInput { get }
  var output: RateViewModelOutput { get }
}

// MARK: - VM
class RateViewModel: RateViewModelType, RateViewModelInput, RateViewModelOutput {
  private let repository: RateRepositoryType
  init(repository: RateRepositoryType) {
    self.repository = repository
  }

  // MARK: - Input
  private var currencyAmount: Double = 1
  func inputCurrencyAmount(_ amount: String) {
    currencyAmount = Double(amount) ?? 1
    fetchRate()
  }

  private var searchText: String = ""
  func searchCurrency(_ search: String) {
    searchText = search
    fetchRate()
  }

  func selectBase(_ base: String) {
    output.currencyBase = base
    fetchRate()
  }

  private var selectedIndexPath = IndexPath()
  func selectItemAtIndexPath(_ indexPath: IndexPath) {
    selectedIndexPath = indexPath
  }

  func viewDidLoad() {
    fetchRate()
  }

  // MARK: - Output
  var currencyBase: String = "USD"
  var numberOfItems: Int {
    currencyRatesFiltered.count
  }

  var onState: ((RateViewModelState) -> Void) = {_ in}
  var selectedItemModel: RateViewCellModelType {
    RateViewCellModel(rate: transformedRate())
  }

  var title: String {
    "\(currencyBase) Latest Rates"
  }

  // MARK: - Helper
  private var currencyRates: [CurrencyRate] = []
  private func fetchRate() {
    let base = output.currencyBase

    currencyRates = []
    output.onState(.loading)
    
    repository.fetch(base: base) { [weak self] in
      switch $0 {
      case .success(let currency):
        self?.currencyRates = currency.rates.sorted { $1.iso > $0.iso }
        self?.output.onState(.loaded)
      case .failure(let error):
        self?.output.onState(.error(error))
      }
    }
  }

  private func transformedRate() -> CurrencyRate {
    var rate = currencyRatesFiltered[selectedIndexPath.row]
    rate.value *= currencyAmount

    return rate
  }

  // MARK: - Filter
  private var currencyRatesFiltered: [CurrencyRate] {
    filter.filter(data: currencyRates)
  }

  private var filter: Filter<CurrencyRate>  {
    Filter(filters: [filterSearch])
  }

  private var filterSearch: Filter<CurrencyRate>.Handler {
    return {[unowned self]  in
      guard searchText.count > 0 else { return $0 }

      return $0.filter {
        $0.iso.lowercased().contains(self.searchText)
      }
    }
  }

  // MARK: - IO Declaration
  var input: RateViewModelInput { self }
  var output: RateViewModelOutput { self }
}
