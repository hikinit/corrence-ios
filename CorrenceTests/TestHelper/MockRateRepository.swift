//
//  MockRateRepository.swift
//  CorrenceTests
//
//  Created by hikinit on 08/09/20.
//

import Foundation

class MockRateRepository: RateRepository {
  override func fetch(base: String, completion: @escaping (Result<Currency, Error>) -> Void) {
    var currency = Currency(base: base, rates: [])
    currency.rates.append(CurrencyRate(iso: "EUR", value: 0.84))
    currency.rates.append(CurrencyRate(iso: "GBP", value: 0.75))
    currency.rates.append(CurrencyRate(iso: "IDR", value: 14700))
    currency.rates.append(CurrencyRate(iso: "JPY", value: 106))
    currency.rates.append(CurrencyRate(iso: "SGD", value: 1.36))

    completion(.success(currency))
  }
}

