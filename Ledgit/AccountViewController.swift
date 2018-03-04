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
    @IBOutlet var cardViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet var cardViewBottomConstraint: NSLayoutConstraint!
    weak var presenter: SettingsPresenter?
    var previousFrame: CGRect?
    let padding:CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecognizers()
        setupTextFields()
        setupButton()
        setupView()
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
    
        nameTextField.text(LedgitUser.current.name)
        emailTextField.text(LedgitUser.current.email)
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
        guard let name = nameTextField.text?.strip(), !name.isEmpty else {
            nameTextField.errorMessage = "Cannot leave name empty"
            return
        }
        
        guard let email = emailTextField.text?.strip(), !email.isEmpty else {
            emailTextField.errorMessage = "Cannot leave email empty"
            return
        }
        
        presenter?.updateUser(name: name, email: email)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.cardViewCenterConstraint.isActive = false
            self.cardViewBottomConstraint.constant = keyboardSize.height + 15
            self.cardViewBottomConstraint.isActive = true
        })
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.cardViewBottomConstraint.constant = 15
            self.cardViewCenterConstraint.isActive = true
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
