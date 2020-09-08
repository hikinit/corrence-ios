//
//  RateCoordinator.swift
//  Corrence
//
//  Created by hikinit on 08/09/20.
//

import UIKit

class RateCoordinator: NavigationCoordinator {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []

  required init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let controller = RateViewController(nibName: "RateViewController", bundle: nil)
    navigationController.pushViewController(controller, animated: true)
  }
}
