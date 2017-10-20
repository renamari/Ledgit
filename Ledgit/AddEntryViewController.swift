//
//  AddEntryViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import SearchTextField

class AddEntryViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryTextField: SearchTextField!
    @IBOutlet weak var currencyTextField: SearchTextField!
    @IBOutlet weak var paymentTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    
    var owningTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        
        setupTextFields()
        
        setupNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupButton() {
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        closeButton.layer.cornerRadius = 25
        closeButton.layer.masksToBounds = true
        closeButton.clipsToBounds = true
    }
    
    func setupTextFields() {
        guard let user = Service.shared.currentUser else { return }

        dateTextField.delegate = self
        
        locationTextField.delegate = self
        
        descriptionTextField.delegate = self
        
        categoryTextField.theme.cellHeight = 44
        categoryTextField.theme.bgColor = UIColor.black.withAlphaComponent(0.8)
        categoryTextField.theme.separatorColor = UIColor.black.withAlphaComponent(0.9)
        categoryTextField.theme.separatorColor = .clear
        categoryTextField.font = .futuraMedium17
        categoryTextField.theme.fontColor = .white
        categoryTextField.startVisible = true
        categoryTextField.comparisonOptions = [.caseInsensitive]
        categoryTextField.filterStrings(user.categories)
        categoryTextField.delegate = self
        categoryTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.categoryTextField.text = item.title
            self.categoryTextField.resignFirstResponder()
        }
        
        currencyTextField.theme.cellHeight = 44
        currencyTextField.theme.bgColor = UIColor.black.withAlphaComponent(0.8)
        currencyTextField.theme.separatorColor = UIColor.black.withAlphaComponent(0.9)
        currencyTextField.theme.separatorColor = .clear
        currencyTextField.font = .futuraMedium17
        currencyTextField.theme.fontColor = .white
        currencyTextField.startVisible = true
        currencyTextField.comparisonOptions = [.caseInsensitive]
        currencyTextField.startVisible = true
        currencyTextField.filterStrings(Currency.all.map{ $0.name })
        currencyTextField.delegate = self
        currencyTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.currencyTextField.text = item.title
            self.currencyTextField.resignFirstResponder()
        }
        
        amountTextField.delegate = self
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
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
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension AddEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case dateTextField:
            locationTextField.becomeFirstResponder()
            
        case locationTextField:
            descriptionTextField.becomeFirstResponder()
            
        case descriptionTextField:
            descriptionTextField.resignFirstResponder()
        
        case amountTextField:
            amountTextField.resignFirstResponder()
            
        default:
            break
        }
        
        return true
    }
}
