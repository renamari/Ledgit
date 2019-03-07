//
//  CategorySelectionViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/26/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

protocol CategorySelectionDelegate: class {
    func selected(_ category: String)
}

class CategorySelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate: CategorySelectionDelegate?
    lazy var filteredCategories: [String] = []
    var categories: [String] {
        return LedgitUser.current.categories
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.contentOffset.y = searchBar.frame.height
    }

    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

extension CategorySelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCategories = categories.filter {
            $0.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension CategorySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !filteredCategories.isEmpty ? filteredCategories.count : categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorySelectionCell", for: indexPath)
        let category = !filteredCategories.isEmpty ? filteredCategories[indexPath.row] : categories[indexPath.row]

        cell.textLabel?.text(category)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let category = !filteredCategories.isEmpty ? filteredCategories[indexPath.row] : categories[indexPath.row]
        delegate?.selected(category)
        dismiss(animated: true, completion: nil)
    }
}
