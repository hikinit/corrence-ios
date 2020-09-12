//
//  RateViewCell.swift
//  Corrence
//
//  Created by hikinit on 09/09/20.
//

import UIKit

class RateViewCell: UITableViewCell, FromNIB {
  @IBOutlet weak var currencyValueLabel: UILabel!
  @IBOutlet weak var currencySymbolLabel: UILabel!
  @IBOutlet weak var symbolView: SymbolView!
  
  func configure(with viewModel: RateViewCellModelType) {
    currencyValueLabel.text = viewModel.output.currencyValue
    currencySymbolLabel.text = viewModel.output.currencySymbol
  }
}
