//
//  RateViewModel.swift
//  Corrence
//
//  Created by hikinit on 07/09/20.
//

import Foundation

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
  var onError: ((Error) -> Void) { get set }
  var reloadData: (() -> Void) { get set }
  var selectedItemModel: RateViewCellModelType { get }
  var title: Observable<String> { get }
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

  var onError: ((Error) -> Void) = {_ in}
  var reloadData: (() -> Void) = {}
  var selectedItemModel: RateViewCellModelType {
    RateViewCellModel(rate: transformedRate())
  }

  var title: Observable<String> {
    Observable("\(currencyBase) Latest Rates")
  }

  // MARK: - Helper
  private var currencyRates: [CurrencyRate] = []
  private func fetchRate() {
    let base = output.currencyBase
    repository.fetch(base: base) { [weak self] in
      switch $0 {
      case .success(let currency):
        self?.currencyRates = currency.rates.sorted { $1.iso > $0.iso }
        self?.output.reloadData()
      case .failure(let error):
        self?.output.onError(error)
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
