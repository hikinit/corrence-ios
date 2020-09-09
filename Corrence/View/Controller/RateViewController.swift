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

    setupBinding()
    setupTableView()
    viewModel.input.viewDidLoad()
  }

  // MARK: - Binding
  private func setupBinding() {
    viewModel.output.title.bind { title in
      DispatchQueue.main.async {
        self.title = title
      }
    }

    viewModel.output.reloadData = { [weak self] in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }

  // MARK: - Table View
  private func setupTableView() {
    tableView.dataSource = self

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
}

extension RateViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.output.numberOfItems
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    let currency = viewModel.output.currencyRates[indexPath.row]
    cell.textLabel?.text = "\(currency.iso) \(currency.value)"

    return cell
  }

}
