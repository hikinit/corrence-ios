//
//  StateMessageView.swift
//  Corrence
//
//  Created by hikinit on 13/09/20.
//

import UIKit

class StateMessageView: NibView {
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var messageTypeView: UILabel!
  @IBOutlet weak var messageDescriptionView: UILabel!

  func configure(type: String, description: String, symbol: String?) {
    messageTypeView.text = type.uppercased()
    messageDescriptionView.text = description

    guard let symbol = symbol,
          let icon = UIImage(systemName: symbol) else {
      return
    }

    iconImageView.image = icon
  }
}
