//
//  CategoriesViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/23/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    var categories:[String] = []
    var actionViewBackground:UIView?
    var actionViewTag = 1234
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    func setupTableView(){
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        fetchCategories()
    }
    
    func fetchCategories(){
        Model.model.fetchCategories{ [unowned self] (results) in
            self.categories = results
            self.categoriesTableView.reloadData()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.categoryAction, sender: Action.add)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryActionViewController = segue.destination as? CategoryActionViewController{
            UIView.animate(withDuration: 0.25, animations: {
                self.actionViewBackground = UIView(frame: self.view.frame)
                self.actionViewBackground?.alpha = 0.7
                self.actionViewBackground?.backgroundColor = .black
                self.actionViewBackground?.tag = self.actionViewTag
                self.view.addSubview(self.actionViewBackground!)
            })
            
            if let action = sender as? Action{
                switch action {
                case .add:
                    categoryActionViewController.delegate = self
                    categoryActionViewController.action = action
                default:
                    categoryActionViewController.delegate = self
                    categoryActionViewController.action = action
                    categoryActionViewController.category = categories[categoriesTableView.indexPathForSelectedRow!.row]
                }
            }
        }
    }
}

extension CategoriesViewController: CategoryActionDelegate{
    func dismissAnimation(){
        if let actionView = view.viewWithTag(actionViewTag){
            UIView.animate(withDuration: 0.45, animations: {
                actionView.alpha = 0
            }, completion: { (successful) in
                if successful{
                    actionView.removeFromSuperview()
                }
            })
        }
    }
    
    func categoryAdded(category: String) {
        let numRows = categoriesTableView.numberOfRows(inSection: 0)
        categories.append(category)
        
        categoriesTableView.beginUpdates()
        categoriesTableView.insertRows(at: [IndexPath(row: numRows, section: 0)], with: .left)
        categoriesTableView.endUpdates()
        
        dismissAnimation()
    }
    
    func categoryUpdated(category: String) {
        let selectedIndexPath = categoriesTableView.indexPathForSelectedRow!
        
        categoriesTableView.beginUpdates()
        let cell = categoriesTableView.cellForRow(at: selectedIndexPath)!
        cell.textLabel?.text = category
        categoriesTableView.endUpdates()
        
        dismissAnimation()
    }
    
    func cancelled(){
        dismissAnimation()
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 1. If user swipes to delete
        if editingStyle == .delete {
            
            // 2. Create local variables for the section and selected row
            let selectedRow = indexPath.row
            
            let category = categories[selectedRow]
            
            Model.model.removeCategory(with: category){ [unowned self] (success) in
                self.categories.remove(at: selectedRow)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.categoryAction, sender: Action.edit)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.categoryName, for: indexPath) 
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category
        
        return cell
    }
}
