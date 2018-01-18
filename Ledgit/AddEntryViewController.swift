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
    @IBOutlet weak var exchangeRateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var paymentPickerCashButton: UIButton!
    @IBOutlet weak var paymentPickerCreditButton: UIButton!
    var isConnected: Bool { return Reachability.isConnectedToNetwork() }
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
        setupObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        activeTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        activeTextField.resignFirstResponder()
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
        
        dateTextField.setTitleVisible(true)
        locationTextField.setTitleVisible(true)
        descriptionTextField.setTitleVisible(true)
        currencyTextField.setTitleVisible(true)
        amountTextField.setTitleVisible(true)
        categoryTextField.setTitleVisible(true)
        exchangeRateTextField.setTitleVisible(true)
        dateTextField.text = Date().toString(style: .long)
        
        // Initially hide the exchange rate text field
        if isConnected && !Currency.rates.isEmpty {
            exchangeRateTextField.frame.size.height = 0
            exchangeRateTextField.isHidden = true
        } else {
            exchangeRateTextField.frame.size.height = categoryTextField.frame.size.height
            exchangeRateTextField.errorMessage = "Not connected. Enter an exchange rate."
            exchangeRateTextField.isHidden = false
        }
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
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
        
        guard let amountString = amountTextField.text?.strip() else {
            amountTextField.errorMessage = "Enter an amount"
            return
        }
        
        var rate: Double = 1.0
        if !exchangeRateTextField.isHidden {
            guard let exchangeRate = exchangeRateTextField.text?.strip() else { return }
            rate <= Double(exchangeRate)
        } else if !Currency.rates.isEmpty {
            if currency == LedgitUser.current.homeCurrency {
                rate = 1
            } else {
                rate = Currency.rates[currency.code]!
            }
        }
        
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
            "currency": currency.code,
            "homeCurrency": LedgitUser.current.homeCurrency.code,
            "exchangeRate": rate,
            "paymentType": paymentType.rawValue,
            "cost": amount,
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
        categoryTextField.resignFirstResponder()
    }
}

extension AddEntryViewController: CurrencySelectionDelegate {
    func selected(_ currencies: [Currency]) {
        selectedCurrency = currencies.first
        currencyTextField.text = selectedCurrency?.name
        currencyTextField.resignFirstResponder()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        switch textField {
        case dateTextField:
            datePicker = UIDatePicker()
            datePicker?.datePickerMode = .date
            datePicker?.backgroundColor = .white
            datePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            dateTextField.inputView = datePicker
            dateTextField.inputAccessoryView = createToolbar()
            dateTextField.errorMessage = nil
            if let dateString = dateTextField.text {
                let date = dateString.toDate(withFormat: nil)
                datePicker?.setDate(date, animated: false)
            }
            
        case currencyTextField:
            resignFirstResponder()
            currencyTextField.errorMessage = nil
            
            let currencySelectionViewController = CurrencySelectionViewController.instantiate(from: .trips)
            currencySelectionViewController.delegate = self
            currencySelectionViewController.allowsMultipleSelection = false
            
            let navigationController = UINavigationController(rootViewController: currencySelectionViewController)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: currencySelectionViewController, action: #selector(CurrencySelectionViewController.dismissViewController))
            doneButton.tintColor = .ledgitBlue
            navigationController.navigationBar.isTranslucent = false
            navigationController.topViewController?.navigationItem.setRightBarButton(doneButton, animated: true)
            
            present(navigationController, animated: true, completion: nil)
            
        case amountTextField:
            amountTextField.errorMessage = nil
            amountTextField.inputAccessoryView = createToolbar()
            if let text = amountTextField.text {
                amountTextField.text = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            }
            
        case categoryTextField:
            resignFirstResponder()
            categoryTextField.errorMessage = nil
            
            let categorySelectionViewController = CategorySelectionViewController.instantiate(from: .trips)
            categorySelectionViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: categorySelectionViewController)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: categorySelectionViewController, action: #selector(CategorySelectionViewController.dismissViewController))
            doneButton.tintColor = .ledgitBlue
            navigationController.navigationBar.isTranslucent = false
            navigationController.topViewController?.navigationItem.setRightBarButton(doneButton, animated: true)
            
            present(navigationController, animated: true, completion: nil)
            
        case locationTextField:
            locationTextField.errorMessage = nil
        
        case descriptionTextField:
            descriptionTextField.errorMessage = nil
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTextField, let text = textField.text?.strip() {
            textField.text = "\(LedgitUser.current.homeCurrency.symbol) \(text)"
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
