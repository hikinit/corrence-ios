//
//  RateViewController.swift
//  Corrence
//
//  Created by hikinit on 08/09/20.
//

import UIKit

class RateViewController: UIViewController, FromNIB {
  // MARK: - Outlet
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Initializer
  private var viewModel: RateViewModel
  init(viewModel: RateViewModel) {
    self.viewModel = viewModel
    super.init(nibName: Self.nibName, bundle: Self.nibBundle)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
