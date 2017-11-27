//
//  TripActionViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/5/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import Eureka
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
    
    var presenter: TripsPresenter?
    let budgetPickerButtonHeight: CGFloat = 20
    var activeTextField = UITextField()
    var delegate: TripActionDelegate?
    var method: TripActionMethod = .add
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
                budgetPickerDailyButton.backgroundColor = .ledgitNavigationTextGray
                budgetPickerMonthlyButton.backgroundColor = .clear
                budgetPickerTripButton.backgroundColor = .clear
                
            case .monthly:
                budgetPickerLabel.text = "MONTHLY"
                budgetPickerMonthlyButton.backgroundColor = .ledgitNavigationTextGray
                budgetPickerDailyButton.backgroundColor = .clear
                budgetPickerTripButton.backgroundColor = .clear
                
            case .trip:
                budgetPickerLabel.text = "TRIP"
                budgetPickerTripButton.backgroundColor = .ledgitNavigationTextGray
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
        
        actionButton.createBorder(radius: 10)
    }
    
    func setupTextFields() {
        if method == .edit {

            guard let trip = trip, let user = LedgitUser.current else {
                navigationController?.popViewController(animated: true)
                showAlert(with: Constants.ClientErrorMessages.errorGettingTrip)
                return
            }
            
            nameTextField.text = trip.name
            startDateTextField.text = trip.startDate
            endDateTextField.text = trip.endDate
            budgetTextField.text = "\(user.homeCurrency.symbol) \(trip.budget)"
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
        budgetPickerDailyButton.createBorder(radius: budgetPickerButtonHeight / 2, color: .ledgitNavigationTextGray)
        budgetPickerMonthlyButton.createBorder(radius: budgetPickerButtonHeight / 2, color: .ledgitNavigationTextGray)
        budgetPickerTripButton.createBorder(radius: budgetPickerButtonHeight / 2, color: .ledgitNavigationTextGray)
        
        if method == .edit {
            guard let trip = trip else {
                navigationController?.popViewController(animated: true)
                showAlert(with: Constants.ClientErrorMessages.errorGettingTrip)
                return
            }
            
            budgetSelection = trip.budgetSelection
        } else {
            budgetSelection = .daily
        }
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
            showAlert(with: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        guard
            let key = presenter?.manager.trips.childByAutoId().key,
            let owner = LedgitUser.current?.key
        else {
            showAlert(with: Constants.ClientErrorMessages.authenticationError)
            return
        }
         
         let dict: NSDictionary = [
         "name": name,
         "startDate": startDate,
         "endDate": endDate,
         "currencies": selectedCurrencies.map{ $0.code },
         "dailyBudget": Double(budget.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!,
         "image": "rome-icon",
         "users": "",
         "key": key,
         "owner": owner
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
            showAlert(with: Constants.ClientErrorMessages.emptyTextFields)
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
        if segue.identifier == Constants.SegueIdentifiers.currencySelection {
            guard let destinationViewController = segue.destination as? CurrencySelectionViewController else { return }
            destinationViewController.delegate = self
            destinationViewController.currencies = selectedCurrencies
            
            activeTextField.resignFirstResponder()
        }
    }
}

extension TripActionViewController: UITextFieldDelegate {

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
                let date = dateString.toDate(withFormat: nil)
                datePicker?.setDate(date, animated: false)
            }
    
        } else if textField == currenciesTextField {
            performSegue(withIdentifier: Constants.SegueIdentifiers.currencySelection, sender: self)
            
        } else if textField == budgetTextField {
            textField.inputAccessoryView = createToolbar()
            
            if let text = textField.text {
                textField.text = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == budgetTextField {
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
