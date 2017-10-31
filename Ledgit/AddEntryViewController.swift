//
//  AddEntryViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import Eureka
import SearchTextField

class AddEntryViewController: FormViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableFrameView: UIView!
    
    var owningTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        
        setupLayout()
        
        setupForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupLayout(){
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
    
    func setupForm() {
        DateRow.defaultCellSetup = {cell, row in cell.textLabel?.textColor = .white}
        
        form
            +++ Section()
            
            <<< DateRow("entryDate") {
                let formatter = DateFormatter()
                formatter.locale = .current
                formatter.dateStyle = .long
                $0.dateFormatter = formatter
                $0.title = "Date:"
                $0.value = Date()
                
                }.onCellSelection { (cell, row) in
                    cell.textLabel?.textColor = .white
                    
                }.cellUpdate { (cell, row) in
                    cell.selectionStyle = .blue
                    cell.backgroundColor = .clear
                    cell.textLabel?.textColor = .white
                    cell.textLabel?.font = .futuraMedium17
                    cell.detailTextLabel?.textColor = .white
                    cell.detailTextLabel?.font = .futuraMedium17
                }
            
            <<< TextRow("location"){
                $0.title = "City:"
                $0.placeholder = "Paris"
                
                }.cellUpdate { (cell, row) in
                    cell.selectionStyle = .blue
                    cell.backgroundColor = .clear
                    cell.textLabel?.textColor = .white
                    cell.textLabel?.font = .futuraMedium17
                    cell.textField.textColor = .white
                    cell.textField.font = .futuraMedium17
                }

            <<< AlertRow<String>() {
                $0.title = "Currencies:"
                $0.selectorTitle = "Select a currency"
                $0.options = Currency.all.map { $0.name }
                $0.value = Currency.USD.name
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .ledgitBlue
                }.cellUpdate { (cell, row) in
                    cell.selectionStyle = .blue
                    cell.backgroundColor = .clear
                    cell.textLabel?.textColor = .white
                    cell.textLabel?.font = .futuraMedium17
                    //cell.detailTextLabel?.textColor = .white
                    cell.detailTextLabel?.font = .futuraMedium17
                }
    
    }
    
    func setupButton() {
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        closeButton.layer.cornerRadius = 25
        closeButton.layer.masksToBounds = true
        closeButton.clipsToBounds = true
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        /*
        guard let date = dateTextField.text?.strip(),
            let location = locationTextField.text?.strip(),
            let description = descriptionTextField.text?.strip(),
            let category = categoryTextField.text?.strip(),
            let currency = currencyTextField.text?.strip(),
            let amountString = amountTextField.text?.strip(),
            let amount = Double(amountString),
            let paymentType = paymentTypeSegmentedControl.titleForSegment(at: paymentTypeSegmentedControl.selectedSegmentIndex),
            let owningTrip = owningTrip,
            let name = Service.shared.currentUser?.key else {
                showAlert(with: Constants.ClientErrorMessages.emptyTextFields)
                return
        }
        
        let key = Service.shared.entries.childByAutoId().key
        
        let entry: NSDictionary = [
            "key":key,
            "date":date,
            "location":location,
            "description":description,
            "category":category,
            "currency":currency,
            "paymentType":paymentType,
            "cost":amount,
            "paidBy":name,
            "owningTrip":owningTrip.key
        ]
        
        Service.shared.createNew(entry: entry)
        
        dismiss(animated: true, completion: nil)
 */
    }
}
