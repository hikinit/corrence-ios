//
//  Debouncer.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//  From https://github.com/DabbyNdubisi

import Foundation

class Debouncer {
  private let delay: TimeInterval
  private var timer: Timer?

  var handler: () -> Void

  init(delay: TimeInterval, handler: @escaping () -> Void) {
    self.delay = delay
    self.handler = handler
  }

  func call() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] _ in
      self?.handler()
    })
  }

  func invalidate() {
    timer?.invalidate()
    timer = nil
  }
}
