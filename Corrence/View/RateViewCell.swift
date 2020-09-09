//
//  RateViewCell.swift
//  Corrence
//
//  Created by hikinit on 09/09/20.
//

import UIKit

class RateViewCell: UITableViewCell, FromNIB {
  @IBOutlet weak var currencyNameLabel: UILabel!
  @IBOutlet weak var currencyValueLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    setupConstraint()
  }

  func configure(with viewModel: RateViewCellModelType) {
    currencyNameLabel.text = viewModel.output.currencyIsoCode
    currencyValueLabel.text = viewModel.output.currencyValue
  }

  private func setupConstraint() {
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}
