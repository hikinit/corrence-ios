//
//  SymbolPickerViewController.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import UIKit

class SymbolPickerViewController: UIViewController, FromNIB {
  init() {
    super.init(nibName: Self.nibName, bundle: Self.nibBundle)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
