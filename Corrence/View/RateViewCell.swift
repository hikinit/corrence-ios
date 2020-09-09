//
//  RateViewCell.swift
//  Corrence
//
//  Created by hikinit on 09/09/20.
//

import UIKit

class RateViewCell: UITableViewCell, FromNIB {
  @IBOutlet weak var currencyFlagImageView: UIImageView!
  @IBOutlet weak var currencyNameLabel: UILabel!
  @IBOutlet weak var currencyValueLabel: UILabel!
  @IBOutlet weak var currencySymbolLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }

  func configure(with viewModel: RateViewCellModelType) {
    currencyNameLabel.text = viewModel.output.currencyIsoCode
    currencyValueLabel.text = viewModel.output.currencyValue
    currencySymbolLabel.text = viewModel.output.currencySymbol

    setupCountryFlag(viewModel.output.currencyIsoCode.lowercased())
  }

  private func setupCountryFlag(_ code: String) {
    guard let image = UIImage(named: "flag/\(code)") else {
      currencyFlagImageView.image = UIImage(named: "flag/generic")
      return
    }

    currencyFlagImageView.image = image
  }

  private func setupUI() {
    currencyFlagImageView.layer.cornerRadius = 4
    currencyFlagImageView.clipsToBounds = true
  }
}
