//
//  SymbolPickerViewController.swift
//  Corrence
//
//  Created by hikinit on 10/09/20.
//

import UIKit

class SymbolPickerViewController: UIViewController, FromNIB {
  // MARK: - Outlet
  @IBOutlet weak var tableView: UITableView!

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

  private func setupBinding() {
    title = viewModel.output.title

    viewModel.output.reloadData = { [weak self] in
      DispatchQueue.main.async {
        self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    tableView.dataSource = self
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    viewModel.input.selectItemAtIndexPath(indexPath)
    let cellViewModel = viewModel.output.selectedItemModel
    cell.textLabel?.text = cellViewModel.output.symbolDescription

    return cell
  }
}
