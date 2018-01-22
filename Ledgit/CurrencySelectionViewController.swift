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
    lazy var currencies: [Currency] = []
    lazy var filteredCurrencies: [Currency] = []
    var allowsMultipleSelection = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.selected(currencies)
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
        filteredCurrencies = Currency.all.filter {
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
        return !filteredCurrencies.isEmpty ? filteredCurrencies.count : Currency.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.currency, for: indexPath) as! CurrencyTableViewCell
        let currency = !filteredCurrencies.isEmpty ? filteredCurrencies[indexPath.row] : Currency.all[indexPath.row]

        cell.configure(with: currency)
        
        if currencies.contains(currency) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
        let selectedCurrency = !filteredCurrencies.isEmpty ? filteredCurrencies[indexPath.row] : Currency.all[indexPath.row]
        
        if allowsMultipleSelection == false {
            currencies.append(selectedCurrency)
            delegate?.selected(currencies)
            dismiss(animated: true, completion: nil)
            
        } else {
            if cell.accessoryType == .none {
                currencies.append(selectedCurrency)
                cell.accessoryType = .checkmark
            } else {
                guard let index = currencies.index(of: selectedCurrency) else { return }
                currencies.remove(at: index)
                cell.accessoryType = .none
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
