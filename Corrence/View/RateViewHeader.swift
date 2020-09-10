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

class RateViewHeader: UIView, FromNIB {
  // MARK: - Outlet
  @IBOutlet var view: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var flagImageView: UIImageView!
  @IBOutlet weak var currencyAmountTextField: UITextField!

  weak var delegate: RateViewHeaderDelegate?

  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupNib()
    setupView()
    setupTextField()
    setupGestureRecognizer()
    setupConstraint()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupNib()
    setupView()
    setupConstraint()
    setupGestureRecognizer()
    setupGestureRecognizer()
  }

  // MARK: - Setup View
  private func setupNib() {
    let nib = UINib(nibName: Self.nibName, bundle: Self.nibBundle)
    nib.instantiate(withOwner: self, options: nil)
  }

  private func setupView() {
    addSubview(view)
    
    containerView.layer.cornerRadius = 8
    flagImageView.layer.cornerRadius = 4
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

  // MARK: - Gesture Recognizer
  private func setupGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(symbolDidTap))

    flagImageView.addGestureRecognizer(tapGesture)
  }

  @objc private func symbolDidTap() {
    delegate?.symbolDidTap()
  }

  // MARK: - Constraint
  private func setupConstraint(){
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor),
      view.bottomAnchor.constraint(equalTo: bottomAnchor),
      view.leadingAnchor.constraint(equalTo: leadingAnchor),
      view.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}
