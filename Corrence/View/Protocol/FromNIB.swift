//
//  NIBLoadable.swift
//  Corrence
//
//  Created by hikinit on 08/09/20.
//

import UIKit

protocol FromNIB: UIResponder {
  static var nibName: String { get }
  static var nibBundle: Bundle { get }
}

extension FromNIB {
  static var nibName: String {
    String(describing: Self.self)
  }

  static var nibBundle: Bundle {
    Bundle(for: Self.self)
  }
}
