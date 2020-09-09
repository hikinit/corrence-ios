//
//  RateViewCellModel.swift
//  Corrence
//
//  Created by hikinit on 09/09/20.
//

import Foundation

protocol RateViewCellModelInput {}

protocol RateViewCellModelOutput {
  var currencyIsoCode: String { get }
  var currencyValue: String { get }
  var currencySymbol: String { get }
}

protocol RateViewCellModelType {
  var output: RateViewCellModelOutput { get }
}

// MARK: - VM
class RateViewCellModel: RateViewCellModelType, RateViewCellModelInput, RateViewCellModelOutput {
  private let rate: CurrencyRate
  init(rate: CurrencyRate) {
    self.rate = rate
  }

  // MARK: - Output
  var currencyIsoCode: String {
    rate.iso
  }

  var currencyValue: String {
    numberFormatter().string(from: NSNumber(value: rate.value))!
  }

  var currencySymbol: String {
    let nf = numberFormatter(style: .currency, fraction: (0, 0))
    let currency = nf.string(from: NSNumber(value: rate.value))!

    return currency.filter { !$0.isNumber && !$0.isWhitespace }
  }

  // MARK: - Helper
  func numberFormatter(
    style: NumberFormatter.Style = .none,
    fraction: (Int, Int) = (3, 6)
  ) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.allowsFloats = true
    formatter.minimumFractionDigits = fraction.0
    formatter.maximumFractionDigits = fraction.1
    formatter.currencyCode = currencyIsoCode
    formatter.numberStyle = style

    return formatter
  }

  // MARK: - IO Declaration
  var output: RateViewCellModelOutput { self }
}
