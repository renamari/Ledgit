//
//  AddEntryViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
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
    @IBOutlet weak var exchangeRateTextField: SkyFloatingLabelTextField!
    @IBOutlet var textFields: [SkyFloatingLabelTextField]!
    @IBOutlet weak var paymentPickerCashButton: UIButton!
    @IBOutlet weak var paymentPickerCreditButton: UIButton!
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
        dateTextField.text = Date().toString(style: .long)
        
        currencyTextField.text = selectedCurrency.name
        amountTextField.inputAccessoryView = createToolbar()
        exchangeRateTextField.inputAccessoryView = createToolbar()
        dateTextField.inputAccessoryView = createToolbar()
        
        // Initially hide the exchange rate text field
        if !Currency.rates.isEmpty, let exchangeRate =  Currency.rates[selectedCurrency.code] {
            exchangeRateTextField.text = "\(exchangeRate)"
        } else if selectedCurrency == LedgitUser.current.homeCurrency {
            exchangeRateTextField.text = "1.00"
        }
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
        
        let key = Service.shared.entries.childByAutoId().key
        let entry: NSDictionary = [
            "key": key,
            "date": date,
            "location": location,
            "description": description,
            "category": category,
            "currency": selectedCurrency.code,
            "homeCurrency": LedgitUser.current.homeCurrency.code,
            "exchangeRate": exchangeRate,
            "paymentType": paymentType.rawValue,
            "cost": (amount / 100),
            "paidBy": LedgitUser.current.key,
            "owningTrip": owningTripKey
        ]
        
        presenter?.create(entry: entry)
        dismiss(animated: true, completion: nil)
    }
}

extension AddEntryViewController: CategorySelectionDelegate {
    func selected(_ category: String) {
        selectedCategory = category
        categoryTextField.text = category
    }
}

extension AddEntryViewController: CurrencySelectionDelegate {
    func selected(_ currencies: [Currency]) {
        guard let currency = currencies.first else { return }
        selectedCurrency = currency
        currencyTextField.text = currency.name
        amountTextFieldChanged(amountTextField)
    }
}

extension AddEntryViewController: UITextFieldDelegate {
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        guard let info = notification.userInfo else { return }
        guard let keyboard = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = keyboard.height
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        scrollView.contentInset = .zero
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
            doneButton.tintColor = .ledgitBlue
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
            doneButton.tintColor = .ledgitBlue
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
                let date = dateString.toDate(withFormat: nil)
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
            
        default: break
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
