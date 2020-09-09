//
//  RateViewModel.swift
//  Corrence
//
//  Created by hikinit on 07/09/20.
//

import Foundation

// MARK: - IO Protocol
protocol RateViewModelInput {
  func selectBase(_ string: String)
  func viewDidLoad()
}

protocol RateViewModelOutput: AnyObject {
  var currencyBase: String { get set }
  var currencyRates: [CurrencyRate] { get set }
  var numberOfItems: Int { get }
  var onError: ((Error) -> Void) { get set }
  var reloadData: (() -> Void) { get set }
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
  func selectBase(_ base: String) {
    fetchRate(base)
  }

  func viewDidLoad() {
    fetchRate(currencyBase)
  }

  // MARK: - Output
  var currencyBase: String = "USD"
  var currencyRates: [CurrencyRate] = []
  var numberOfItems: Int {
    currencyRates.count
  }
  var onError: ((Error) -> Void) = {_ in}
  var reloadData: (() -> Void) = {}

  var title: Observable<String> {
    Observable("\(currencyBase) Latest Rates")
  }

  // MARK: - Helper
  private func fetchRate(_ base: String) {
    output.currencyBase = base
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

  // MARK: - IO Declaration
  var input: RateViewModelInput { self }
  var output: RateViewModelOutput { self }
}
