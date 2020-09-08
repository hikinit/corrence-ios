//
//  AppCoordinator.swift
//  Corrence
//
//  Created by hikinit on 08/09/20.
//

import UIKit

class AppCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    let navigationController = UINavigationController()
    let rateCoordinator = RateCoordinator(navigationController: navigationController)

    addChild(rateCoordinator)
    rateCoordinator.start()

    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }
}
