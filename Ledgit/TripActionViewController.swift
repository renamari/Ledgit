//
//  TripActionViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/5/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

protocol TripActionDelegate {
    func added(trip dict: NSDictionary)
    func edited(_ trip: LedgitTrip)
}

class TripActionViewController: UIViewController {
    @IBOutlet weak var mapIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var startDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var endDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var budgetTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var currenciesTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var budgetPickerLabel: UILabel!
    @IBOutlet weak var budgetPickerDailyButton: UIButton!
    @IBOutlet weak var budgetPickerMonthlyButton: UIButton!
    @IBOutlet weak var budgetPickerTripButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: TripsPresenter?
    let budgetPickerButtonHeight: CGFloat = 20
    var activeTextField = UITextField()
    var delegate: TripActionDelegate?
    var method: LedgitAction = .add
    var trip: LedgitTrip?
    var selectedCurrencies: [Currency] = [.USD]
    var datePicker: UIDatePicker?
    
    var isLoading:Bool = false {
        didSet {
            switch isLoading {
            case true: startLoading()
            case false: stopLoading()
            }
        }
    }
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }
    
    var budgetSelection: BudgetSelection = .daily {
        didSet {
            switch budgetSelection {
            case .daily:
                budgetPickerLabel.text = "DAILY"
                budgetPickerDailyButton.backgroundColor = LedgitColor.navigationTextGray
                budgetPickerMonthlyButton.backgroundColor = .clear
                budgetPickerTripButton.backgroundColor = .clear
                
            case .monthly:
                budgetPickerLabel.text = "MONTHLY"
                budgetPickerMonthlyButton.backgroundColor = LedgitColor.navigationTextGray
                budgetPickerDailyButton.backgroundColor = .clear
                budgetPickerTripButton.backgroundColor = .clear
                
            case .trip:
                budgetPickerLabel.text = "TRIP"
                budgetPickerTripButton.backgroundColor = LedgitColor.navigationTextGray
                budgetPickerDailyButton.backgroundColor = .clear
                budgetPickerMonthlyButton.backgroundColor = .clear
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupTextFields()
        
        setupBars()
        
        setupBudgetPicker()
        
        setupObservers()
    }
    
    func setupView() {
        switch method {
        case .add:
            title = "Create Trip"
            titleLabel.text = "Enter some details of your trip"
            actionButton.setTitle("Create Trip", for: .normal)
            
        case .edit:
            title = "Edit Trip"
            titleLabel.text = "Change the details of your trip"
            actionButton.setTitle("Save", for: .normal)
        }
        
        actionButton.roundedCorners(radius: Constants.cornerRadius.button)
    }
    
    func setupTextFields() {
        if method == .edit {
            guard let trip = trip else {
                navigationController?.popViewController(animated: true)
                showAlert(with: Constants.clientErrorMessages.errorGettingTrip)
                return
            }
            
            nameTextField.text = trip.name
            startDateTextField.text = trip.startDate
            endDateTextField.text = trip.endDate
            budgetTextField.text = "\(LedgitUser.current.homeCurrency.symbol) \(trip.budget)"
            currenciesTextField.text = trip.currencies.map{ $0.code }.joined(separator: ",")
            selectedCurrencies = trip.currencies
            budgetSelection = trip.budgetSelection
        }
        
        nameTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        budgetTextField.delegate = self
        currenciesTextField.delegate = self
    }
    
    func setupBudgetPicker() {
        budgetPickerDailyButton.roundedCorners(radius: budgetPickerButtonHeight / 2, borderColor: LedgitColor.navigationTextGray)
        budgetPickerMonthlyButton.roundedCorners(radius: budgetPickerButtonHeight / 2, borderColor: LedgitColor.navigationTextGray)
        budgetPickerTripButton.roundedCorners(radius: budgetPickerButtonHeight / 2, borderColor: LedgitColor.navigationTextGray)
        
        if method == .edit {
            guard let trip = trip else {
                navigationController?.popViewController(animated: true)
                showAlert(with: Constants.clientErrorMessages.errorGettingTrip)
                return
            }
            
            budgetSelection = trip.budgetSelection
        } else {
            budgetSelection = .daily
        }
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func setupBars(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = true
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
    
    func performSaveAction() {
        guard
            let name = nameTextField.text,
            let startDate = startDateTextField.text,
            let endDate = endDateTextField.text,
            let budget = budgetTextField.text
        else {
            showAlert(with: Constants.clientErrorMessages.emptyTextFields)
            return
        }
        
        guard
            let key = presenter?.manager.trips.childByAutoId().key
        else {
            showAlert(with: Constants.clientErrorMessages.authenticationError)
            return
        }
         
         let dict: NSDictionary = [
         "name": name,
         "startDate": startDate,
         "endDate": endDate,
         "currencies": selectedCurrencies.map{ $0.code },
         "dailyBudget": Double(budget.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!,
         "budgetSelection": budgetSelection.rawValue,
         "image": "rome-icon",
         "users": "",
         "key": key,
         "owner": LedgitUser.current.key
         ]
        
        delegate?.added(trip: dict)
        navigationController?.popViewController(animated: true)
    }
    
    func performUpdateAction() {
        guard
            let name = nameTextField.text,
            let startDate = startDateTextField.text,
            let endDate = endDateTextField.text,
            let budget = budgetTextField.text
        else {
            showAlert(with: Constants.clientErrorMessages.emptyTextFields)
            return
        }
        
        if var trip = trip {
            trip.name = name
            trip.startDate = startDate
            trip.endDate = endDate
            trip.budget = Double(budget.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!
            trip.currencies = selectedCurrencies
            trip.budgetSelection = budgetSelection
            
            delegate?.edited(trip)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func budgetPickerDailyButtonPressed(_ sender: Any) {
        budgetSelection = .daily
    }
    
    @IBAction func budgetPickerMonthlyButtonPressed(_ sender: Any) {
        budgetSelection = .monthly
    }
    
    @IBAction func budgetPickerTripButtonPressed(_ sender: Any) {
        budgetSelection = .trip
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        
        switch method {
        case .edit:
            performUpdateAction()
        case .add:
            performSaveAction()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        activeTextField.resignFirstResponder()
        if segue.identifier == Constants.segueIdentifiers.currencySelection {
            guard let destinationViewController = segue.destination as? CurrencySelectionViewController else { return }
            destinationViewController.delegate = self
            destinationViewController.currencies = selectedCurrencies
        }
    }
}

extension TripActionViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        guard let info = notification.userInfo else { return }
        guard let keyboard = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboard.height, right: 0)
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = .zero
        scrollView.contentInset = contentInset
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if textField == startDateTextField || textField == endDateTextField {
            datePicker = UIDatePicker()
            datePicker?.datePickerMode = .date
            datePicker?.backgroundColor = .white
            datePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            textField.inputView = datePicker
            textField.inputAccessoryView = createToolbar()
            
            if let dateString = (textField == startDateTextField) ? trip?.startDate : trip?.endDate {
                let date = dateString.toDate()
                datePicker?.setDate(date, animated: false)
            }
    
        } else if textField == currenciesTextField {
            performSegue(withIdentifier: Constants.segueIdentifiers.currencySelection, sender: self)
            
        } else if textField == budgetTextField {
            textField.inputAccessoryView = createToolbar()
            
            if let text = textField.text {
                textField.text = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == budgetTextField {
            guard let text = textField.text else { return }
            textField.text = "\(LedgitUser.current.homeCurrency.symbol) \(text)"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField, budgetTextField, currenciesTextField:
            textField.resignFirstResponder()
            
        default: break
        }
        return true
    }
    
    @objc func doneTapped() {
        activeTextField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        activeTextField.text = formatter.string(from: sender.date)
    }
}

extension TripActionViewController: CurrencySelectionDelegate {
    func selected(_ currencies: [Currency]) {
        selectedCurrencies = currencies
        currenciesTextField.text = currencies.map{ $0.code }.joined(separator: ", ")
        currenciesTextField.resignFirstResponder()
    }
}
