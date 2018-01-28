//
//  EditEntryViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 1/27/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditEntryViewController: UIViewController {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var locationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var currencyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var categoryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var exchangeRateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var paymentPickerCashButton: UIButton!
    @IBOutlet weak var paymentPickerCreditButton: UIButton!
    
    
    var isConnected: Bool { return Reachability.isConnectedToNetwork() }
    var activeTextField: UITextField?
    var selectedCategory: String?
    var datePicker: UIDatePicker?
    var entry: LedgitEntry?
    
    //TODO: Change this currency
    var selectedCurrency: Currency = .USD {
        didSet {
            if let exchangeRate =  Currency.rates[selectedCurrency.code] {
                exchangeRateTextField.text = "\(exchangeRate)"
            }
        }
    }
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }
    
    var paymentType: PaymentType = .cash {
        didSet {
            switch paymentType {
            case .cash:
                paymentPickerCreditButton.backgroundColor = .clear
                paymentPickerCashButton.backgroundColor = .white
            case .credit:
                paymentPickerCreditButton.backgroundColor = .white
                paymentPickerCashButton.backgroundColor = .clear
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
    }
}
