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
    weak var delegate: CategorySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CategorySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LedgitUser.current?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorySelectionCell", for: indexPath)

        if let categories = LedgitUser.current?.categories {
            cell.textLabel?.text = categories[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let categories = LedgitUser.current?.categories {
            let category = categories[indexPath.row]
            delegate?.selected(category)
            dismiss(animated: true, completion: nil)
        }
    }
}
