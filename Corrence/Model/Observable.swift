//
//  Observable.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

class Observable<Value> {
  typealias Token = NSObjectProtocol
  typealias Observer = (Value) -> Void

  private var observers: [(Token, Observer)] = []
  public var value: Value {
    didSet {
      notify()
    }
  }

  init(_ value: Value) {
    self.value = value
  }

  @discardableResult
  func bind(observer: @escaping Observer) -> Token {
    defer {
      observer(value)
    }

    let token = NSObject()
    observers.append((token, observer))

    return token
  }

  func unbind(_ observer: NSObjectProtocol) {
    observers.removeAll { $0.0.isEqual(observer) }
  }

  private func notify() {
    observers.forEach { $0.1(value) }
  }

  deinit {
    observers.removeAll()
  }
}
