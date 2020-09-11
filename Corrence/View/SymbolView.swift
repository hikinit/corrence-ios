//
//  SymbolView.swift
//  Corrence
//
//  Created by hikinit on 11/09/20.
//

import UIKit

@IBDesignable
class SymbolView: UIView, FromNIB {
  @IBOutlet weak var view: UIStackView!
  @IBOutlet weak var symbolFlag: UIImageView!
  @IBOutlet weak var symbolCodeLabel: UILabel!
  @IBOutlet weak var symbolDescription: UILabel!

  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupNib()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupNib()
  }

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setupNib()
  }

  // MARK: - Load Nib
  private func setupNib() {
    let nib = UINib(nibName: Self.nibName, bundle: Self.nibBundle)
    nib.instantiate(withOwner: self, options: nil)
    addSubview(view)

    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor),
      view.bottomAnchor.constraint(equalTo: bottomAnchor),
      view.leadingAnchor.constraint(equalTo: leadingAnchor),
      view.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}
