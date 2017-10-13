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
    private var H_PADDING:CGFloat = 20
    private var V_PADDING:CGFloat = 20
    private var BTN_HEIGHT:CGFloat = 40
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
        tableView?.rowHeight = tableFrameView.frame.height / 5
        tableView?.bounces = false
        tableView?.isScrollEnabled = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.sectionHeaderHeight = 0
        tableView?.sectionFooterHeight = 0
        tableFrameView.addSubview(tableView!)
    }
    
    func setupButton(){
        createButton.layer.cornerRadius = 10
        createButton.layer.masksToBounds = true
        createButton.clipsToBounds = true
    }
    
    func setupForm(){
        DateRow.defaultRowInitializer = { row in row.minimumDate = Date() }
        
        form
            +++ Section()
            <<< TextRow("name") {
                $0.title = "Trip Name"
                $0.cell.titleLabel?.textColor = .kColor3F6072
                $0.cell.titleLabel?.font = .futuraMedium15
                $0.placeholder = "Mexico 2017"
            }
            
            
            <<< DateInlineRow("startDate") {
                $0.title = "Trip Start Date"
                $0.cell.textLabel?.textColor = .kColor3F6072
                $0.cell.textLabel?.font = .futuraMedium15
                $0.value = Date().addingTimeInterval(60*60*24)
                $0.dateFormatter?.dateFormat = "MMMM dd, yyyy"
                }
                .onChange { row in
                    let endRow: DateInlineRow! = self.form.rowBy(tag: "endDate")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate() { cell, row in
                        cell.datePicker.datePickerMode = .date
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            
            <<< DateInlineRow("endDate"){
                $0.title = "Trip End Date"
                $0.cell.textLabel?.textColor = .kColor3F6072
                $0.cell.textLabel?.font = .futuraMedium15
                $0.value = Date().addingTimeInterval(60*60*25)
                $0.dateFormatter?.dateFormat = "MMMM dd, yyyy"
                }
                .onChange { [weak self] row in
                    let startRow: DateInlineRow! = self?.form.rowBy(tag: "startDate")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    }
                    else{
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { cell, dateRow in
                        cell.datePicker.datePickerMode = .date
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DecimalRow("budget"){
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.nilSymbol = ""
                formatter.zeroSymbol = Model.model.currentUser!.homeCurrency.symbol
                formatter.currencySymbol = Model.model.currentUser!.homeCurrency.symbol
                
                $0.cell.textLabel?.textColor = .kColor3F6072
                $0.cell.titleLabel?.font = .futuraMedium15
                $0.title = "Daily Trip Budget"
                $0.placeholder = "$50"
                $0.formatter = formatter
            }
            
            <<< MultipleSelectorRow<String>("currencies") {
                $0.title = "Currencies"
                $0.cell.textLabel?.textColor = .kColor3F6072
                $0.cell.textLabel?.font = .futuraMedium15
                $0.options = Currency.allCodes
                $0.value = ["USD"]
                }
                .onPresent { from, to in
                    from.navigationController?.navigationBar.isHidden = false
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(AddTripViewController.multipleSelectorDone))
                    //multipleSelectorDone(_:)
        }
        
    }
    
    @objc func multipleSelectorDone() { //_ item:UIBarButtonItem
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        let results = form.values()
        
        guard let name = results["name"] as? String else{
            showAlert(with: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        guard let budget = results["budget"] as? Double else{
            showAlert(with: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        guard let currencies = results["currencies"] as? NSSet else{
            return
        }
        
        guard let start = results["startDate"] as? Date else{
            return
        }
        
        guard let end = results["endDate"] as? Date else{
            return
        }
        
        let key = Model.model.trips.childByAutoId().key
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
        
        self.delegate?.addedTrip(dict: dict)
        self.navigationController?.popViewController(animated: true)
    }
}
