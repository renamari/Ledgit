//
//  CurrencySelectionViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

protocol CurrencySelectionDelegate: class {
    func selected(_ currencies: [Currency])
}

class CurrencySelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate: CurrencySelectionDelegate?
    lazy var selectedCurrencies: [Currency] = []
    lazy var filteredCurrencies: [Currency] = []
    var limitedCurrencies: [Currency]?
    var allowsMultipleSelection = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.selected(selectedCurrencies)
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        
        tableView.contentOffset.y = searchBar.frame.height
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = allowsMultipleSelection
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 60
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

extension CurrencySelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let visibleCurrencies = limitedCurrencies ?? Currency.all
        filteredCurrencies = visibleCurrencies.filter {
            $0.code.lowercased().contains(searchText.lowercased()) ||
            $0.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension CurrencySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let visibleCurrencies = limitedCurrencies ?? Currency.all
        return !filteredCurrencies.isEmpty ? filteredCurrencies.count : visibleCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let visibleCurrencies = limitedCurrencies ?? Currency.all
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.currency, for: indexPath) as! CurrencyTableViewCell
        let currency = !filteredCurrencies.isEmpty ? filteredCurrencies[indexPath.row] : visibleCurrencies[indexPath.row]

        cell.configure(with: currency)
        
        if selectedCurrencies.contains(currency) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
        let visibleCurrencies = limitedCurrencies ?? Currency.all
        let selectedCurrency = !filteredCurrencies.isEmpty ? filteredCurrencies[indexPath.row] : visibleCurrencies[indexPath.row]
        
        if allowsMultipleSelection {
            
            if cell.accessoryType == .none {
                selectedCurrencies.append(selectedCurrency)
                cell.accessoryType = .checkmark
            } else {
                guard let index = selectedCurrencies.index(of: selectedCurrency) else { return }
                selectedCurrencies.remove(at: index)
                cell.accessoryType = .none
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else {
            selectedCurrencies.append(selectedCurrency)
            delegate?.selected(selectedCurrencies)
            dismiss(animated: true, completion: nil)
        }
    }
}
