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
    let viewModel = RateViewModel(repository: RateRepository())
    let controller = RateViewController(viewModel: viewModel)
    navigationController.pushViewController(controller, animated: true)
  }
}
