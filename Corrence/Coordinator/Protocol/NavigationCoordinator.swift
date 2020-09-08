//
//  NavigationCoordinator.swift
//  Corrence
//
//  Created by hikinit on 08/09/20.
//

import UIKit

protocol NavigationCoordinator: Coordinator {
  var navigationController: UINavigationController { get }

  init(navigationController: UINavigationController)
}
