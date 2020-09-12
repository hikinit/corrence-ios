//
//  RateViewHeader.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import UIKit

protocol RateViewHeaderDelegate: RateViewController {
  func currencyAmountDidReturn(amount: String)
  func symbolDidTap()
}

class RateViewHeader: NibView {
  // MARK: - Outlet
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var currencyAmountTextField: UITextField!
  @IBOutlet weak var symbolView: SymbolView!

  // MARK: - Action
  @IBAction func symbolViewDidTap(_ sender: UITapGestureRecognizer) {
    delegate?.symbolDidTap()
  }

  weak var delegate: RateViewHeaderDelegate?

  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
    setupTextField()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupView()
    setupTextField()
  }

  // MARK: - View
  func configure(with viewModel: SymbolViewModel) {
    symbolView.configure(with: viewModel)
  }

  private func setupView() {
    containerView.layer.cornerRadius = 8
  }

  // MARK: - Text Field
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
    defer { currencyAmountTextField.resignFirstResponder() }
    guard let amount = currencyAmountTextField.text else { return }

    delegate?.currencyAmountDidReturn(amount: amount)
  }

  @objc private func textFieldDidCancel() {
    currencyAmountTextField.resignFirstResponder()
  }
}
