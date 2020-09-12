//
//  SymbolPickerViewCell.swift
//  Corrence
//
//  Created by hikinit on 12/09/20.
//

import UIKit

class SymbolPickerViewCell: UITableViewCell, FromNIB {
  @IBOutlet weak var symbolView: SymbolView!

  func configure(with viewModel: SymbolViewModelType) {
    symbolView.configure(with: viewModel)
  }
}
