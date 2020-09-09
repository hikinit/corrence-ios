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
    currency.rates.append(CurrencyRate(iso: "BTC", value: 0.000099))
    currency.rates.append(CurrencyRate(iso: "EUR", value: 0.849407))
    currency.rates.append(CurrencyRate(iso: "GBP", value: 0.771359))
    currency.rates.append(CurrencyRate(iso: "IDR", value: 14838.592228))
    currency.rates.append(CurrencyRate(iso: "JPY", value: 105.905485))
    currency.rates.append(CurrencyRate(iso: "SGD", value: 1.370805))

    completion(.success(currency))
  }
}

