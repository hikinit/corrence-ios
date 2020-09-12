//
//  SymbolPickerCoordinator.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import UIKit

class SymbolPickerCoordinator: NavigationCoordinator {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []
  var onCompleted: () -> Void = {}
  var parentCoordinator: RateCoordinator?

  required init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let repository = SymbolsRepository(
      cacheRepository: CacheSymbolsRepository(),
      externalRepository: ExternalSymbolsRepository())
    let viewModel = SymbolPickerViewModel(repository: repository)

    let controller = SymbolPickerViewController(viewModel: viewModel)
    controller.delegate = self

    let navCon = UINavigationController(rootViewController: controller)

    navigationController.present(navCon, animated: true, completion: onCompleted)
  }
}

extension SymbolPickerCoordinator: SymbolPickerViewControllerDelegate {
  func symbolDidPick(viewModel: SymbolViewModelType) {
    parentCoordinator?.symbolDidPick(viewModel)
    navigationController.dismiss(animated: true)
  }
}
