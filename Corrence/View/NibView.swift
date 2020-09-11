//
//  NibView.swift
//  Corrence
//
//  Created by hikinit on 11/09/20.
//

import UIKit

class NibView: UIView, FromNIB {
  weak var contentView: UIView!

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
    guard let view = UINib(nibName: Self.nibName, bundle: Self.nibBundle)
            .instantiate(withOwner: self, options: nil).first as? UIView else {
      preconditionFailure("Can't instantiate NIB, please check the configuration")
    }

    contentView = view
    addSubview(view)

    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor),
      view.bottomAnchor.constraint(equalTo: bottomAnchor),
      view.leadingAnchor.constraint(equalTo: leadingAnchor),
      view.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}
