//
//  RateViewHeader.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import UIKit

protocol RateViewHeaderDelegate: RateViewController {
  func currencyAmountDidReturn(amount: String)
}

class RateViewHeader: UIView, FromNIB {
  @IBOutlet var view: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var flagImageView: UIImageView!
  @IBOutlet weak var currencyAmountTextField: UITextField!

  weak var delegate: RateViewHeaderDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupNib()
    setupView()
    setupTextField()
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

  private func setupTextField() {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
    toolbar.setItems([
      UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(textFieldDidCancel)),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(textFieldDidReturn))
    ], animated: true)

    currencyAmountTextField.inputAccessoryView = toolbar
  }

  @objc private func textFieldDidReturn() {
    defer {
      currencyAmountTextField.resignFirstResponder()
    }

    guard let amount = currencyAmountTextField.text else { return }

    delegate?.currencyAmountDidReturn(amount: amount)
  }

  @objc private func textFieldDidCancel() {
    currencyAmountTextField.resignFirstResponder()
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
