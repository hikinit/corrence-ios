//
//  Coordinator.swift
//  Corrence
//
//  Created by hikinit on 08/09/20.
//

import Foundation

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  func start()
}

extension Coordinator {
  func addChild(_ child: Coordinator) {
    childCoordinators.append(child)
  }

  func removeChild(_ child: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== child }
  }
}
