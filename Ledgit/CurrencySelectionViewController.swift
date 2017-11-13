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
    weak var delegate: CurrencySelectionDelegate?
    lazy var currencies: [Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.selected(currencies)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
    }
}

extension CurrencySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Currency.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.currency) as! CurrencyTableViewCell
        let currency = Currency.all[indexPath.row]

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
        let selectedCurrency = Currency.all[indexPath.row]
        
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
