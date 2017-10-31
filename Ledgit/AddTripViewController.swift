//
//  AddTripViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import Stevia
import Eureka
import Firebase

protocol AddTripDelegate {
    func addedTrip(dict: NSDictionary)
}

class AddTripViewController: FormViewController {
    @IBOutlet weak var mapIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var tableFrameView: UIView!
    var delegate: AddTripDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        setupButton()
        
        setupForm()
    }
    
    func setupLayout(){
        title = "Create Trip"
    
        tableView?.frame = CGRect(x: 0, y: 0, width: tableFrameView.frame.width, height: tableFrameView.frame.height)
        tableView?.backgroundColor = .clear
        tableView?.rowHeight = tableFrameView.frame.height / 6
        tableView?.bounces = false
        tableView?.isScrollEnabled = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.sectionHeaderHeight = 0
        tableView?.sectionFooterHeight = 0
        tableView?.separatorColor = .clear
        tableFrameView.addSubview(tableView!)
    }
    
    func setupButton(){
        createButton.layer.cornerRadius = 10
        createButton.layer.masksToBounds = true
        createButton.clipsToBounds = true
    }
    
    func setupForm(){
    
        form
            +++ Section()
            <<< TextRow("name") {
                $0.title = "Name"
                $0.cell.titleLabel?.textColor = .ledgitNavigationTextGray
                $0.cell.titleLabel?.font = .futuraMedium15
                $0.placeholder = "Mexico 2017"
            }
            
            <<< DateRow("startDate"){
                $0.title = "Start Date"
                $0.cell.textLabel?.textColor = .ledgitNavigationTextGray
                $0.cell.textLabel?.font = .futuraMedium15
                $0.value = Date()
                let formatter = DateFormatter()
                formatter.locale = .current
                formatter.dateStyle = .long
                $0.dateFormatter = formatter
                }.onChange{ [weak self] row in
                    let endRow: DateRow! = self?.form.rowBy(tag: "endDate")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = row.value!.add(components: 1.day)//Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
            
            <<< DateRow("endDate"){
                $0.title = "End Date"
                $0.cell.textLabel?.textColor = .ledgitNavigationTextGray
                $0.cell.textLabel?.font = .futuraMedium15
                $0.value = Date().add(components: 1.day)
                let formatter = DateFormatter()
                formatter.locale = .current
                formatter.dateStyle = .long
                $0.dateFormatter = formatter
                }.onChange{ [weak self] row in
                    let startRow: DateRow! = self?.form.rowBy(tag: "startDate")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    }
                    else{
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                }
            
            <<< SegmentedRow<String>("period") {
                $0.options = ["Daily", "Monthly", "Trip"]
                $0.cell.segmentedControl.tintColor = .ledgitNavigationTextGray
                $0.value = $0.options?.first
                }.onChange{ [weak self] row in
                    let budgetRow: DecimalRow! = self?.form.rowBy(tag: "budget")
                    guard let period = row.value else { return }
                    budgetRow.title = "\(period) Budget"
                    budgetRow.updateCell()
                }
            
            <<< DecimalRow("budget"){
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.nilSymbol = ""
                formatter.zeroSymbol = Service.shared.currentUser!.homeCurrency.symbol
                formatter.currencySymbol = Service.shared.currentUser!.homeCurrency.symbol
                
                $0.cell.textLabel?.textColor = .ledgitNavigationTextGray
                $0.cell.titleLabel?.font = .futuraMedium15
                $0.title = "Daily Budget"
                $0.placeholder = "$40"
                $0.formatter = formatter
            }
            
            <<< MultipleSelectorRow<String>("currencies") {
                $0.title = "Currencies"
                $0.cell.textLabel?.textColor = .ledgitNavigationTextGray
                $0.cell.textLabel?.font = .futuraMedium15
                $0.options = Currency.all.map { $0.code }
                $0.value = ["USD"]
                }
                .onPresent { from, to in
                    from.navigationController?.navigationBar.isHidden = false
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(AddTripViewController.multipleSelectorDone))
                    //multipleSelectorDone(_:)
        }
        
    }
    
    @objc func multipleSelectorDone() { //_ item:UIBarButtonItem
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        let results = form.values()
        
        guard let name = results["name"] as? String else {
            showAlert(with: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        guard let budget = results["budget"] as? Double else {
            showAlert(with: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        guard let currencies = results["currencies"] as? NSSet else { return }
        
        guard let start = results["startDate"] as? Date else { return }
        
        guard let end = results["endDate"] as? Date else { return }
        
        let key = Service.shared.trips.childByAutoId().key
        let owner = UserDefaults.standard.value(forKey: "uid") as! String
        
        let dict: NSDictionary = [
            "name": name,
            "startDate": start.toString(withFormat: nil),
            "endDate": end.toString(withFormat: nil),
            "currencies": Array(currencies),
            "dailyBudget": budget,
            "image": "rome-icon",
            "users": "",
            "key": key,
            "owner": owner
        ]
        
        delegate?.addedTrip(dict: dict)
        navigationController?.popViewController(animated: true)
    }
}
