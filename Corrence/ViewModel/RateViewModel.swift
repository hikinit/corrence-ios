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
  var onError: ((Error) -> Void) { get set }
  var reloadData: (() -> Void) { get set }
  var title: String { get }
}

protocol RateViewModelType {
  var input: RateViewModelInput { get }
  var output: RateViewModelOutput { get }
}

// MARK: - VM
class RateViewModel: RateViewModelType, RateViewModelInput, RateViewModelOutput {
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
  var onError: ((Error) -> Void) = {_ in}
  var reloadData: (() -> Void) = {}

  var title: String {
    "\(currencyBase) Latest Rates"
  }

  private func fetchRate(_ base: String) {
    output.currencyBase = base
    repository.fetch(base: base) { [weak self] in
      switch $0 {
      case .success(let currency):
        self?.output.currencyRates = currency.rates
      case .failure(let error):
        self?.output.onError(error)
      }

      self?.output.reloadData()
    }
  }

  // MARK: - IO Declaration
  var input: RateViewModelInput { self }
  var output: RateViewModelOutput { self }

  // MARK: - Privates
  private let repository: RateRepository
}
