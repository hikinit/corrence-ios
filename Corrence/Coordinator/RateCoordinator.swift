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
  var controller: RateViewController?

  required init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let viewModel = RateViewModel(repository: RateRepository())
    let controller = RateViewController(viewModel: viewModel)

    self.controller = controller
    controller.delegate = self

    navigationController.pushViewController(controller, animated: true)
  }

  func symbolDidPick(_ viewModel: SymbolViewModelType) {
    controller?.selectSymbol(viewModel: viewModel)
  }
}

extension RateCoordinator: RateViewControllerDelegate {
  func showSymbolPicker() {
    let symbolPickerCoordinator = SymbolPickerCoordinator(navigationController: navigationController)
    symbolPickerCoordinator.parentCoordinator = self

    symbolPickerCoordinator.onCompleted = { [weak self] in
      self?.removeChild(symbolPickerCoordinator)
    }

    addChild(symbolPickerCoordinator)
    symbolPickerCoordinator.start()
  }
}
