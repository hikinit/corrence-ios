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
    controller.delegate = self

    navigationController.pushViewController(controller, animated: true)
  }
}

extension RateCoordinator: RateViewControllerDelegate {
  func showSymbolPicker() {
    let symbolPickerCoordinator = SymbolPickerCoordinator(navigationController: navigationController)

    symbolPickerCoordinator.onCompleted = { [weak self] in
      self?.removeChild(symbolPickerCoordinator)
    }

    addChild(symbolPickerCoordinator)
    symbolPickerCoordinator.start()
  }
}
