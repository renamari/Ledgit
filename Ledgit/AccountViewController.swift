//
//  AccountViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/23/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AccountViewController: UIViewController {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveButton: UIButton!
    weak var presenter: SettingsPresenter?
    var previousFrame: CGRect?
    let padding:CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupButton()
        setupTextFields()
        setupRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }
    
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:.UIKeyboardWillHide, object: self.view.window)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func setupTextFields() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        let currentUser = LedgitUser.current
        nameTextField.text = currentUser.name
        emailTextField.text = currentUser.email
    }
    
    func setupRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func screenTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        cardView.roundedCorners(radius: Constants.cornerRadius.button)
    }
    
    func setupButton(){
        saveButton.roundedCorners(radius: Constants.cornerRadius.button)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let nameText = nameTextField.text, !nameText.isEmpty else {
            nameTextField.errorMessage = "Cannot leave name empty"
            return
        }
        
        guard let emailText = emailTextField.text, !emailText.isEmpty else {
            emailTextField.errorMessage = "Cannot leave email empty"
            return
        }
        
        let name = nameText.strip()
        let email = emailText.strip()
        
        presenter?.updateUser(name: name, email: email)
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
        guard let frame = previousFrame else{
            return
        }

        UIView.animate(withDuration: 0.25, animations: {
            self.cardView.frame = frame
        })
    }
}

extension AccountViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

extension AccountViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
