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
    var keyboardShowing: Bool = false
    var isConnected: Bool { return Reachability.isConnectedToNetwork }
    var activeTextField: UITextField?
    var selectedCurrency: LedgitCurrency = LedgitUser.current.homeCurrency {
        didSet {
            guard selectedCurrency != LedgitUser.current.homeCurrency else {
                self.exchangeRateTextField.text("1.00")
                return
            }
            
            LedgitCurrency.getRate(between: LedgitUser.current.homeCurrency.code, and: selectedCurrency.code).then { rate in
                self.exchangeRateTextField.text("\(rate)")
                
            }.catch { error in
                Log.critical("In \(self), we were unable to fetch rate between \(LedgitUser.current.homeCurrency.code) selecting \(self.selectedCurrency.code)")
                Log.error(error)
                
                self.exchangeRateTextField.text("1.00")
            }
        
            amountTextField.title = "AMOUNT IN \(selectedCurrency.code.uppercased())"
            amountTextField.selectedTitle = "AMOUNT IN \(selectedCurrency.code.uppercased())"
        }
    }
    var selectedCategory: String?
    var datePicker: UIDatePicker?
    var presenter: TripDetailPresenter?
    var entry: LedgitEntry?
    var parentTrip: LedgitTrip?
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
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextFields()
        setupObservers()
        setupRecognizers()
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
    
    func setupRecognizers() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(gesture:)))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)
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
                showAlert(with: LedgitError.errorGettingEntry)
                dismiss(animated: true, completion: nil)
                return
            }
            
            titleLabel.text("Edit Entry")
            selectedCurrency = entry.currency
            selectedCategory = entry.category
            categoryTextField.text(selectedCategory)
            currencyTextField.text(selectedCurrency.name)
            dateTextField.text(entry.date.toString(style: .full))
            locationTextField.text(entry.location)
            descriptionTextField.text(entry.description)
            amountTextField.text("\(entry.cost)".currencyFormat(with: entry.currency.symbol))
            amountTextField.title = "AMOUNT IN \(selectedCurrency.code.uppercased())"
            exchangeRateTextField.text("\(entry.exchangeRate)")
            
            paymentType = entry.paymentType
            
            deleteButton.isUserInteractionEnabled = true
            deleteButton.isHidden = false
            
        } else {
            dateTextField.text(Date().toString(style: .long))
            currencyTextField.text(selectedCurrency.name)
            
            if selectedCurrency == LedgitUser.current.homeCurrency {
                exchangeRateTextField.text("1.00")
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
        toolBar.tintColor = LedgitColor.coreBlue//UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func swipedDown(gesture: UIGestureRecognizer) {
        guard let swipe = gesture as? UISwipeGestureRecognizer else { return }
        swipe.direction == .down ? dismiss(animated: true, completion: nil) : nil
    }
    
    @objc func doneTapped() {
        amountTextField.resignFirstResponder()
        exchangeRateTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        activeTextField?.text(formatter.string(from: sender.date))
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
    
    func amountTextFieldChanged(_ sender: SkyFloatingLabelTextField) {
        guard let text = sender.text else { return }
        sender.text(text.currencyFormat(with: selectedCurrency.symbol))
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard parentTrip?.key != Constants.projectID.sample else {
            showAlert(with: LedgitError.cannotAddEntriesToSample)
            return
        }
        
        guard let entry = entry else { return }
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to remove this entry? This can't be undone.", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.presenter?.remove(entry)
            self.dismiss(animated: true, completion: nil)
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
    
    func textFieldsValidated() -> Bool {
        var validated = true
        if locationTextField.text?.isEmpty == true {
            locationTextField.errorMessage = "Enter a city"
            validated = false
        }
        
        if descriptionTextField.text?.isEmpty == true {
            descriptionTextField.errorMessage = "Enter a description"
            validated = false
        }
        
        if selectedCategory == nil {
            categoryTextField.errorMessage = "Select a category"
            validated = false
        }
        
        if amountTextField.text?.isEmpty == true {
            amountTextField.errorMessage = "Enter an amount"
            validated = false
        }
        
        if exchangeRateTextField.text?.isEmpty == true {
            exchangeRateTextField.errorMessage = "Enter a rate"
            validated = false
        }
        
        return validated
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard parentTrip?.key != Constants.projectID.sample else {
            showAlert(with: LedgitError.cannotAddEntriesToSample)
            return
        }
        
        guard
            textFieldsValidated(),
            let location = locationTextField.text?.strip(),
            let description = descriptionTextField.text?.strip(),
            let category = selectedCategory,
            let amountString = amountTextField.text?.strip(),
            let exchangeRateString = exchangeRateTextField.text?.strip(),
            let exchangeRate = Double(exchangeRateString),
            let date = dateTextField.text?.strip(),
            let owningTripKey = presenter?.trip.key
        else { return }
        
        let amount = amountString.toDouble()
        
        let convertedCost = Double(amount / exchangeRate)
        
        var key = ""
        if action == .edit, let entry = entry {
            key = entry.key
        } else {
            key = UUID().uuidString
        }
        
        let entryData: NSDictionary = [
            LedgitEntry.Keys.key: key,
            LedgitEntry.Keys.date: date,
            LedgitEntry.Keys.location: location,
            LedgitEntry.Keys.description: description,
            LedgitEntry.Keys.category: category,
            LedgitEntry.Keys.currency: selectedCurrency.code,
            LedgitEntry.Keys.homeCurrency: LedgitUser.current.homeCurrency.code,
            LedgitEntry.Keys.exchangeRate: exchangeRate,
            LedgitEntry.Keys.paymentType: paymentType.rawValue,
            LedgitEntry.Keys.cost: amount,
            LedgitEntry.Keys.convertedCost: convertedCost,
            LedgitEntry.Keys.paidBy: LedgitUser.current.key,
            LedgitEntry.Keys.owningTrip: owningTripKey
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
        categoryTextField.text(category)
    }
}

extension EntryActionViewController: CurrencySelectionDelegate {
    func selected(_ currencies: [LedgitCurrency]) {
        guard let currency = currencies.first else { return }
        selectedCurrency = currency
        currencyTextField.text(currency.name)
        amountTextFieldChanged(amountTextField)
    }
}

extension EntryActionViewController: UITextFieldDelegate {
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let keyboard = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let adjustmentHeight = (keyboard.height + 20) * (show ? -1 : 1)
        scrollView.contentInset.bottom += keyboard.height
        scrollView.scrollIndicatorInsets.bottom += keyboard.height
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard !keyboardShowing else { return }
        guard let info = notification.userInfo else { return }
        guard let keyboard = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom += keyboard.height
        scrollView.scrollIndicatorInsets.bottom += keyboard.height
        keyboardShowing = true
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
        keyboardShowing = false
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
            currencySelectionViewController.limitedCurrencies = parentTrip?.currencies
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
            let cleanedText = text.trimmingCharacters(in: CharacterSet(charactersIn: ".1234567890").inverted)
            textField.text(cleanedText.replacingOccurrences(of: ",", with: ""))

        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTextField {
            guard let text = textField.text else {
                amountTextField.errorMessage = "Enter an amount in \(selectedCurrency.code)"
                return
            }
            let cleanedText = text.trimmingCharacters(in: CharacterSet(charactersIn: ".1234567890").inverted)
            textField.text(cleanedText.currencyFormat(with: selectedCurrency.symbol))
            amountTextField.errorMessage = nil
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
