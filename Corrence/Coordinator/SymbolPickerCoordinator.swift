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

  required init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let controller = SymbolPickerViewController()
    let navCon = UINavigationController(rootViewController: controller)

    navigationController.present(navCon, animated: true, completion: onCompleted)
  }
}
