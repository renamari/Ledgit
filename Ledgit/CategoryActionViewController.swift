//
//  CategoryActionViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/24/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

enum Action {
    case add
    case edit
}

class CategoryActionViewController: UIViewController {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var categoryTextField: SkyFloatingLabelTextField!
    weak var presenter: SettingsPresenter?
    var action: Action = .add
    var category: String?
    var previousFrame: CGRect?
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupButton()
        
        setupRecognizers()
        
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
        
        setupLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:.UIKeyboardWillHide, object: self.view.window)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func setupTextFields(){
        categoryTextField.delegate = self
    }
    
    func setupRecognizers(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func screenTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLabels() {
        switch action {
        case .add:
            cardTitleLabel.text = "Add New Category"
            
        case .edit:
            cardTitleLabel.text = "Edit Category"
            categoryTextField.text = category
        }
    }

    func setupView(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        cardView.createBorder(radius: 10)
    }
    
    func setupButton(){
        saveButton.createBorder(radius: 10)
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let text = categoryTextField.text, !text.isEmpty else {
            categoryTextField.errorMessage = "Cannot leave this empty"
            return
        }
        
        let newCategory = text.strip()
        switch action {
        case .add:
            presenter?.add(newCategory)
        case .edit:
            guard let category = category else { return }
            presenter?.update(category, to: newCategory)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let availableScreen = view.frame.height - keyboardSize.height
        previousFrame = cardView.frame
        
        UIView.animate(withDuration: 0.25, animations: {
            self.cardView.frame.size.height = availableScreen - (2 * self.padding)
            self.cardView.frame.origin.y = self.padding
        })
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let frame = previousFrame else { return }

        UIView.animate(withDuration: 0.25, animations: {
            self.cardView.frame = frame
        })
    }
}

extension CategoryActionViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

extension CategoryActionViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryTextField.resignFirstResponder()
        return true
    }
}
