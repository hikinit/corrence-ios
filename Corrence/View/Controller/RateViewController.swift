//
//  RateViewController.swift
//  Corrence
//
//  Created by hikinit on 08/09/20.
//

import UIKit

protocol RateViewControllerDelegate: AnyObject {
  func showSymbolPicker()
}

class RateViewController: UIViewController, FromNIB {
  // MARK: - Outlet
  @IBOutlet weak var tableView: UITableView!
  lazy var headerView: RateViewHeader = {
    let view = RateViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 120))
    view.delegate = self
    return view
  }()

  weak var delegate: RateViewControllerDelegate?

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
    setupSearchBar()
    setupTableView()
    viewModel.input.viewDidLoad()
  }

  func selectSymbol(viewModel symbolVM: SymbolViewModelType) {
    headerView.configure(with: symbolVM)
    viewModel.input.selectBase(symbolVM.output.symbolCode)
  }

  // MARK: - Binding
  private func setupBinding() {

    viewModel.output.onState = { [weak self] in
      switch $0 {
      case .error(_):
        break
      case .loading:
        break
      case .loaded:
        DispatchQueue.main.async {
          self?.title = self?.viewModel.output.title
          self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
      }
    }
  }

  // MARK: - Search Bar
  private var searchDebouncer: Debouncer?
  private func setupSearchBar() {
    let search = UISearchController(searchResultsController: nil)

    search.searchResultsUpdater = self
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "Search currency..."

    navigationItem.searchController = search
    navigationItem.hidesSearchBarWhenScrolling = false
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
    viewModel.input.inputCurrencyAmount(amount)
  }

  func symbolDidTap() {
    delegate?.showSymbolPicker()
  }
}

// MARK: - Search Delegate
extension RateViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text?.lowercased() else { return }

    guard let searchDebouncer = self.searchDebouncer else {
      let debouncer = Debouncer(delay: 0.4, handler: {})
      self.searchDebouncer = debouncer

      return
    }

    searchDebouncer.invalidate()
    searchDebouncer.handler = { [weak self] in
      self?.viewModel.input.searchCurrency(searchText)
    }
    searchDebouncer.call()
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
