//
//  SymbolPickerViewController.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import UIKit

protocol SymbolPickerViewControllerDelegate: AnyObject {
  func symbolDidPick(viewModel: SymbolViewModelType)
}

class SymbolPickerViewController: UIViewController, FromNIB {
  // MARK: - Outlet
  @IBOutlet weak var tableView: UITableView!

  weak var delegate: SymbolPickerViewControllerDelegate?

  // MARK: - Initializer
  private var viewModel: SymbolPickerViewModelType
  init(viewModel: SymbolPickerViewModelType) {
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

  // MARK: - Binding
  private func setupBinding() {
    viewModel.output.onState = { [weak self] state in
      DispatchQueue.main.async {
        defer {
          self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
          self?.title = self?.viewModel.output.title
        }

        switch state {
        case .error(let error):
          self?.stateDidError(error)
        case .loading:
          self?.stateDidLoading()
        case .loaded:
          self?.stateDidLoaded()
        }
      }
    }
  }

  // MARK: - State Handling
  private func stateDidError(_ error: Error) {
    defer {
      tableView.backgroundView = errorView
    }

    let errorView = StateMessageView(frame: tableView.bounds)
    errorView.configure(type: "Error", description: error.localizedDescription, symbol: "x.square")

    guard let backgroundView = tableView.backgroundView else {
      return
    }

    UIView.transition(
      from: backgroundView,
      to: errorView,
      duration: 0.3,
      options: [.curveEaseInOut, .transitionCrossDissolve],
      completion: nil)
  }

  private func stateDidLoading() {
    let loadingView = StateMessageView(frame: tableView.bounds)
    loadingView.configure(type: "Loading...", description: "", symbol: "arrow.clockwise.icloud")

    UIView.transition(with: loadingView, duration: 1, options: [.transitionCrossDissolve], animations: {
      self.tableView.backgroundView = loadingView
    }, completion: nil)
  }

  private func stateDidLoaded() {
    tableView.backgroundView = nil
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
    let cell = UINib(nibName: SymbolPickerViewCell.nibName, bundle: SymbolPickerViewCell.nibBundle)
    tableView.register(cell, forCellReuseIdentifier: SymbolPickerViewCell.nibName)

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80
  }
}

// MARK: - Search Delegate
extension SymbolPickerViewController: UISearchResultsUpdating {
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

extension SymbolPickerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.output.numberOfItems
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SymbolPickerViewCell.nibName,
            for: indexPath) as? SymbolPickerViewCell else {
      return UITableViewCell()
    }

    viewModel.input.selectItemAtIndexPath(indexPath)
    let cellViewModel = viewModel.output.selectedItemModel
    cell.configure(with: cellViewModel)

    return cell
  }
}

extension SymbolPickerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.input.selectItemAtIndexPath(indexPath)

    delegate?.symbolDidPick(viewModel: viewModel.output.selectedItemModel)
  }
}
