//
//  RateViewHeader.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import UIKit

class RateViewHeader: UIView, FromNIB {
  @IBOutlet var view: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var flagImageView: UIImageView!

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupNib()
    setupView()
    setupConstraint()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupNib()
    setupView()
    setupConstraint()
  }

  private func setupNib() {
    let nib = UINib(nibName: Self.nibName, bundle: Self.nibBundle)
    nib.instantiate(withOwner: self, options: nil)
  }

  private func setupView() {
    addSubview(view)

    containerView.layer.cornerRadius = 8
    flagImageView.layer.cornerRadius = 4
  }

  private func setupConstraint(){
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor),
      view.bottomAnchor.constraint(equalTo: bottomAnchor),
      view.leadingAnchor.constraint(equalTo: leadingAnchor),
      view.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}
