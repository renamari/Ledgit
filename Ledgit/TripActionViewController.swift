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
    func addedTrip(dict: NSDictionary)
    func editedTrip(at index: Int)
}

enum BudgetSelection {
    case daily, monthly, trip
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
    let budgetPickerButtonHeight: CGFloat = 20
    var activeTextField = UITextField()
    var delegate: TripActionDelegate?
    var method: TripActionMethod = .add
    var trip: Trip?
    var selectedCurrencies: [Currency] = []

    var isLoading:Bool = false {
        didSet {
            switch isLoading {
            case true: startLoading()
            case false: stopLoading()
            }
        }
    }
    
    var datePicker: UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .white
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
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
        
        actionButton.layer.cornerRadius = 10
        actionButton.layer.masksToBounds = true
        actionButton.clipsToBounds = true
    }
    
    func setupTextFields() {
        if method == .edit {
            guard let trip = trip else {
                guard let rootViewController = navigationController?.viewControllers.first as? TripsViewController else { return }
                navigationController?.popViewController(animated: true)
                rootViewController.showAlert(with: Constants.ClientErrorMessages.errorGettingTrip)
                return
            }
            
            nameTextField.text = trip.name
            startDateTextField.text = trip.startDate
            endDateTextField.text = trip.endDate
            budgetTextField.text = "\(trip.budget)"
            currenciesTextField.text = trip.currencies.map{ $0.code }.joined(separator: ",")
            selectedCurrencies = trip.currencies
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
        
        budgetSelection = .daily
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
        
        /*
        let key = Service.shared.trips.childByAutoId().key
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
        
        delegate?.addedTrip(dict: dict)
        navigationController?.popViewController(animated: true)
        */
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
            textField.inputView = datePicker
            textField.inputAccessoryView = createToolbar()
            
            if let dateString = textField.text, !dateString.isEmpty {
                let date = dateString.toDate(withFormat: nil)
                datePicker.setDate(date, animated: true)
            }
            
        } else if textField == currenciesTextField {
            performSegue(withIdentifier: Constants.SegueIdentifiers.currencySelection, sender: self)
            
        } else if textField == budgetTextField {
            textField.inputAccessoryView = createToolbar()
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
        currenciesTextField.text = currencies.map{ $0.code }.joined(separator: ",")
    }
}
