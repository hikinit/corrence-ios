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
  var currencyRates: [CurrencyRate] { get set }
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
  private let repository: RateRepository
  init(repository: RateRepository) {
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
  var currencyRates: [CurrencyRate] = []
  var numberOfItems: Int {
    filteredCurrencyRates.count
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
  private func fetchRate() {
    let base = output.currencyBase
    repository.fetch(base: base) { [weak self] in
      switch $0 {
      case .success(let currency):
        self?.output.currencyRates = currency.rates.sorted { $1.iso > $0.iso }
        self?.output.reloadData()
      case .failure(let error):
        self?.output.onError(error)
      }
    }
  }

  private func transformedRate() -> CurrencyRate {
    var rate = filteredCurrencyRates[selectedIndexPath.row]
    rate.value *= currencyAmount

    return rate
  }

  var filteredCurrencyRates: [CurrencyRate] {
    guard searchText.count > 0 else { return currencyRates }

    return currencyRates.filter {
      $0.iso.lowercased().contains(searchText)
    }
  }

  // MARK: - IO Declaration
  var input: RateViewModelInput { self }
  var output: RateViewModelOutput { self }
}
