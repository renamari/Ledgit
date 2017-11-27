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
import SkyFloatingLabelTextField

class AddEntryViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var locationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var currencyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var categoryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var paymentPickerCashButton: UIButton!
    @IBOutlet weak var paymentPickerCreditButton: UIButton!
    var activeTextField = UITextField()
    var selectedCurrency: Currency?
    var selectedCategory: String?
    var datePicker: UIDatePicker?
    var presenter: TripDetailPresenter?
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
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupButtons() {
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        closeButton.createBorder(radius: 25)
        
        paymentPickerCashButton.createBorder(radius: paymentPickerCashButton.frame.height / 2, color: .white)
        paymentPickerCreditButton.createBorder(radius: paymentPickerCreditButton.frame.height / 2, color: .white)
        paymentType = .cash
    }
    
    func setupTextFields() {
        dateTextField.delegate = self
        locationTextField.delegate = self
        descriptionTextField.delegate = self
        currencyTextField.delegate = self
        amountTextField.delegate = self
        categoryTextField.delegate = self

        dateTextField.text = Date().toString(style: .long)
    }
    
    func createToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func doneTapped() {
        activeTextField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        activeTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func multipleSelectorDone() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paymentPickerCashButtonPressed(_ sender: Any) {
        paymentType = .cash
    }
    
    @IBAction func paymentPickerCreditButtonPressed(_ sender: Any) {
        paymentType = .credit
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let location = locationTextField.text?.strip() else {
            locationTextField.errorMessage = "Enter a city"
            return
        }
        
        guard let description = descriptionTextField.text?.strip() else {
            descriptionTextField.errorMessage = "Enter a description"
            return
        }
        
        guard let currency = selectedCurrency else {
            currencyTextField.errorMessage = "Select a currency"
            return
        }
        
        guard let category = selectedCategory else {
            categoryTextField.errorMessage = "Select a category"
            return
        }
        
        guard let amountString = amountTextField.text?.strip(), let amount = Double(amountString) else {
            amountTextField.errorMessage = "Enter an amount"
            return
        }

        guard let date = dateTextField.text?.strip(),
            let owningTripKey = presenter?.trip.key,
            let name = LedgitUser.current?.key else {
                return
        }
        
        let key = Service.shared.entries.childByAutoId().key
        let entry: NSDictionary = [
            "key": key,
            "date": date,
            "location": location,
            "description": description,
            "category": category,
            "currency": currency.code,
            "paymentType": paymentType,
            "cost": amount,
            "paidBy": name,
            "owningTrip": owningTripKey
        ]
        
        presenter?.create(entry: entry)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.categorySelection {
            guard let categorySelectionViewController = segue.destination as? CategorySelectionViewController else { return }
            categorySelectionViewController.delegate = self
        }
    }
}

extension AddEntryViewController: CategorySelectionDelegate {
    func selected(_ category: String) {
        selectedCategory = category
        categoryTextField.text = category
        categoryTextField.resignFirstResponder()
    }
}

extension AddEntryViewController: CurrencySelectionDelegate {
    func selected(_ currencies: [Currency]) {
        selectedCurrency = currencies[0]
        currencyTextField.text = selectedCurrency?.name
        currencyTextField.resignFirstResponder()
    }
}

extension AddEntryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if textField == dateTextField {
            datePicker = UIDatePicker()
            datePicker?.datePickerMode = .date
            datePicker?.backgroundColor = .white
            datePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            textField.inputView = datePicker
            textField.inputAccessoryView = createToolbar()
            
            if let dateString = textField.text {
                let date = dateString.toDate(withFormat: nil)
                datePicker?.setDate(date, animated: false)
            }
            
        } else if textField == currencyTextField {
            textField.resignFirstResponder()
            let currencySelectionViewController = CurrencySelectionViewController.instantiate(from: .trips)
            currencySelectionViewController.delegate = self
            currencySelectionViewController.allowsMultipleSelection = false
            currencySelectionViewController.modalTransitionStyle = .crossDissolve
            present(currencySelectionViewController, animated: true, completion: nil)
            
        } else if textField == amountTextField {
            textField.inputAccessoryView = createToolbar()
            
            if let text = textField.text {
                textField.text = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            }
        } else if textField == categoryTextField {
            textField.resignFirstResponder()
            performSegue(withIdentifier: Constants.SegueIdentifiers.categorySelection, sender: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTextField {
            if let text = textField.text {
                if let user = LedgitUser.current {
                    textField.text = "\(user.homeCurrency.symbol) \(text)"
                } else {
                    textField.text = "\(text)"
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case locationTextField, descriptionTextField, amountTextField, currencyTextField:
            textField.resignFirstResponder()
            
        default: break
        }
        return true
    }
}
