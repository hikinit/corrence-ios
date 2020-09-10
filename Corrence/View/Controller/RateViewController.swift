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
  lazy var headerView: RateViewHeader = {
    let view = RateViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
    view.delegate = self
    return view
  }()

  // MARK: - Initializer
  private var viewModel: RateViewModelType
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
    let rateViewCellNib = UINib(nibName: RateViewCell.nibName, bundle: RateViewCell.nibBundle)
    tableView.register(rateViewCellNib, forCellReuseIdentifier: RateViewCell.nibName)

    tableView.dataSource = self
    tableView.tableHeaderView = headerView
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80
  }
}

// MARK: - Header View Delegate
extension RateViewController: RateViewHeaderDelegate {
  func currencyAmountDidReturn(amount: String) {
    print("CALLED")
    viewModel.input.inputCurrencyAmount(amount)
  }
}


// MARK: - Table Data Source
extension RateViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.output.numberOfItems
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RateViewCell.nibName,
            for: indexPath) as? RateViewCell else {
      return UITableViewCell()
    }

    viewModel.input.selectItemAtIndexPath(indexPath)
    let rateViewCellModel = viewModel.output.selectedItemModel
    cell.configure(with: rateViewCellModel)

    return cell
  }

}
