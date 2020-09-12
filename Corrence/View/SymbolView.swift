//
//  SymbolView.swift
//  Corrence
//
//  Created by hikinit on 11/09/20.
//

import UIKit

@IBDesignable
class SymbolView: NibView {
  @IBOutlet weak var symbolFlagView: UIImageView!
  @IBOutlet weak var symbolCodeLabel: UILabel!
  @IBOutlet weak var symbolDescriptionLabel: UILabel!

  func configure(with viewModel: SymbolViewModelType) {
    symbolCodeLabel.text = viewModel.output.symbolCode
    symbolDescriptionLabel.text = viewModel.output.symbolDescription

    setupCountryFlag(viewModel.output.symbolCode.lowercased())
  }

  private func setupCountryFlag(_ code: String) {
    guard let image = UIImage(named: "flag/\(code)") else {
      symbolFlagView.image = UIImage(named: "flag/generic")
      return
    }

    symbolFlagView.image = image
  }

  override internal func setupUI() {
    backgroundColor = .none
    symbolFlagView.layer.cornerRadius = 4
    symbolFlagView.clipsToBounds = true
  }
}
