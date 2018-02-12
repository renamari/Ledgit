//
//  EntryActionViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EntryActionViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var locationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var currencyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var categoryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var exchangeRateTextField: SkyFloatingLabelTextField!
    @IBOutlet var textFields: [SkyFloatingLabelTextField]!
    @IBOutlet weak var paymentPickerCashButton: UIButton!
    @IBOutlet weak var paymentPickerCreditButton: UIButton!
    var action: LedgitAction = .add
    var editedEntry: Bool = false
    var isConnected: Bool { return Reachability.isConnectedToNetwork() }
    var activeTextField: UITextField?
    var selectedCurrency: Currency = .USD {
        didSet {
            if let exchangeRate =  Currency.rates[selectedCurrency.code] {
                exchangeRateTextField.text = "\(exchangeRate)"
            }
        }
    }
    var selectedCategory: String?
    var datePicker: UIDatePicker?
    var presenter: TripDetailPresenter?
    var entry: LedgitEntry?
    
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
        setupObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        view.endEditing(true)
        activeTextField?.resignFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        activeTextField?.resignFirstResponder()
    }
    
    func setupButtons() {
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        closeButton.roundedCorners(radius: 25)
        
        paymentPickerCashButton.roundedCorners(radius: paymentPickerCashButton.frame.height / 2, borderColor: .white)
        paymentPickerCreditButton.roundedCorners(radius: paymentPickerCreditButton.frame.height / 2, borderColor: .white)
        paymentType = .cash
    }
    
    func setupTextFields() {
        if action == .edit {
            guard let entry = entry else {
                showAlert(with: Constants.clientErrorMessages.errorGettingEntry)
                dismiss(animated: true, completion: nil)
                return
            }
            
            titleLabel.text = "Edit Entry"
            selectedCurrency = entry.currency
            selectedCategory = entry.category
            categoryTextField.text = selectedCategory
            currencyTextField.text = selectedCurrency.name
            dateTextField.text = entry.date.toString(style: .long)
            locationTextField.text = entry.location
            descriptionTextField.text = entry.description
            amountTextField.text = "\(entry.cost)".currencyFormat(with: entry.currency.symbol)
            exchangeRateTextField.text = "\(entry.exchangeRate)"
            
            paymentType = entry.paymentType
            
            deleteButton.isUserInteractionEnabled = true
            deleteButton.isHidden = false
            
        } else {
            dateTextField.text = Date().toString(style: .long)
            currencyTextField.text = selectedCurrency.name
            
            // Initially hide the exchange rate text field
            if !Currency.rates.isEmpty, let exchangeRate =  Currency.rates[selectedCurrency.code] {
                exchangeRateTextField.text = "\(exchangeRate)"
            } else if selectedCurrency == LedgitUser.current.homeCurrency {
                exchangeRateTextField.text = "1.00"
            }
        }
        
        dateTextField.delegate = self
        locationTextField.delegate = self
        descriptionTextField.delegate = self
        currencyTextField.delegate = self
        amountTextField.delegate = self
        categoryTextField.delegate = self
        exchangeRateTextField.delegate = self
        
        dateTextField.setTitleVisible(true)
        locationTextField.setTitleVisible(true)
        descriptionTextField.setTitleVisible(true)
        currencyTextField.setTitleVisible(true)
        amountTextField.setTitleVisible(true)
        categoryTextField.setTitleVisible(true)
        exchangeRateTextField.setTitleVisible(true)
        
        exchangeRateTextField.inputAccessoryView = createToolbar()
        amountTextField.inputAccessoryView = createToolbar()
        dateTextField.inputAccessoryView = createToolbar()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
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
        amountTextField.resignFirstResponder()
        exchangeRateTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        activeTextField?.text = formatter.string(from: sender.date)
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
    
    @IBAction func amountTextFieldChanged(_ sender: SkyFloatingLabelTextField) {
        guard let text = sender.text else { return }
        sender.text = text.currencyFormat(with: selectedCurrency.symbol)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let entry = entry else { return }
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to remove this entry? This can't be undone.", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.presenter?.remove(entry)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        if action == .edit && editedEntry {
            
            let alert = UIAlertController(title: "Just making sure...", message: "It looks like you made some changes, do you want to save them?", preferredStyle: .alert)
            
            let noThanksAction = UIAlertAction(title: "No thanks", style: .destructive, handler: { action in
                self.dismiss(animated: true, completion: nil)
            })
          
            let saveAction = UIAlertAction(title: "Yes please!", style: .cancel, handler: { action in
                self.saveButtonPressed(self)
            })
            
            alert.addAction(saveAction)
            alert.addAction(noThanksAction)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            dismiss(animated: true, completion: nil)
        }
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
        
        guard let category = selectedCategory else {
            categoryTextField.errorMessage = "Select a category"
            return
        }
        
        guard let amountString = amountTextField.text?.strip() else {
            amountTextField.errorMessage = "Enter an amount"
            return
        }
        
        guard let exchangeRateString = exchangeRateTextField.text?.strip(), let exchangeRate = Double(exchangeRateString) else { return }
        
        guard
            let amount = Double(amountString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")),
            let date = dateTextField.text?.strip(),
            let owningTripKey = presenter?.trip.key
        else {
            return
        }
        
        var key = ""
        if action == .edit, let entry = entry {
            key = entry.key
        } else {
            key = Service.shared.entries.childByAutoId().key
        }
        
        let entryData: NSDictionary = [
            "key": key,
            "date": date,
            "location": location,
            "description": description,
            "category": category,
            "currency": selectedCurrency.code,
            "homeCurrency": LedgitUser.current.homeCurrency.code,
            "exchangeRate": exchangeRate,
            "paymentType": paymentType.rawValue,
            "cost": amount,
            "paidBy": LedgitUser.current.key,
            "owningTrip": owningTripKey
        ]
        
        if action == .edit {
            presenter?.update(entry: entryData)
        } else {
            presenter?.create(entry: entryData)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension EntryActionViewController: CategorySelectionDelegate {
    func selected(_ category: String) {
        selectedCategory = category
        categoryTextField.text = category
    }
}

extension EntryActionViewController: CurrencySelectionDelegate {
    func selected(_ currencies: [Currency]) {
        guard let currency = currencies.first else { return }
        selectedCurrency = currency
        currencyTextField.text = currency.name
        amountTextFieldChanged(amountTextField)
    }
}

extension EntryActionViewController: UITextFieldDelegate {
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        guard let info = notification.userInfo else { return }
        guard let keyboard = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = keyboard.height
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        scrollView.contentInset = .zero
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        editedEntry = true
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case currencyTextField:
            currencyTextField.errorMessage = nil
            let currencySelectionViewController = CurrencySelectionViewController.instantiate(from: .trips)
            currencySelectionViewController.delegate = self
            currencySelectionViewController.allowsMultipleSelection = false
            currencySelectionViewController.title = "Select Currency"
            
            let navigationController = UINavigationController(rootViewController: currencySelectionViewController)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: currencySelectionViewController, action: #selector(CurrencySelectionViewController.dismissViewController))
            doneButton.tintColor = LedgitColor.coreBlue
            navigationController.navigationBar.isTranslucent = false
            navigationController.topViewController?.navigationItem.setRightBarButton(doneButton, animated: true)
            
            activeTextField?.resignFirstResponder()
            present(navigationController, animated: true, completion: nil)
            
            return false
            
        case categoryTextField:
            categoryTextField.errorMessage = nil
            
            let categorySelectionViewController = CategorySelectionViewController.instantiate(from: .trips)
            categorySelectionViewController.delegate = self
            categorySelectionViewController.title = "Select Category"
            
            let navigationController = UINavigationController(rootViewController: categorySelectionViewController)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: categorySelectionViewController, action: #selector(CategorySelectionViewController.dismissViewController))
            doneButton.tintColor = LedgitColor.coreBlue
            navigationController.navigationBar.isTranslucent = false
            navigationController.topViewController?.navigationItem.setRightBarButton(doneButton, animated: true)
            
            activeTextField?.resignFirstResponder()
            present(navigationController, animated: true, completion: nil)
            return false
            
        case dateTextField:
            datePicker = UIDatePicker()
            datePicker?.datePickerMode = .date
            datePicker?.backgroundColor = .white
            datePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            dateTextField.inputView = datePicker
            dateTextField.errorMessage = nil
            if let dateString = dateTextField.text {
                let date = dateString.toDate()
                datePicker?.setDate(date, animated: false)
            }
            return true
            
        default: return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        switch textField {
        case locationTextField:
            locationTextField.errorMessage = nil
        
        case descriptionTextField:
            descriptionTextField.errorMessage = nil
        
        case amountTextField:
            guard let text = textField.text else { return }
            textField.text = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTextField {
            guard let text = textField.text else { return }
            textField.text = text.currencyFormat()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.text == "" {
            switch textField {
            case locationTextField:
                locationTextField.errorMessage = "Enter a city"
                
            case descriptionTextField:
                descriptionTextField.errorMessage = "Enter a description"
                
            case currencyTextField:
                currencyTextField.errorMessage = "Select a currency"
                
            case categoryTextField:
                categoryTextField.errorMessage = "Select a category"
                
            case amountTextField:
                amountTextField.errorMessage = "Enter an amount"
            default: break
            }
        }
        return true
    }
}
