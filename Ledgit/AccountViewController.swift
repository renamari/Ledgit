//
//  AccountViewController.swift
//  Ledgit
//
//  Created by Camden Madina on 8/23/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

protocol AccountActionDelegate {
    func cancelled()
    func accountUpdated()
}

class AccountViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate:AccountActionDelegate?
    var oldFrame:CGRect?
    let padding:CGFloat = 20
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 2. Remove observers for keyboard
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func setupKeyboardNotifications(){
        // 1. Add notification obeservers that will alert app when keyboard displays
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:.UIKeyboardWillHide, object: self.view.window)
    }
    
    func setupTextFields(){
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        if let name = Model.model.currentUser?.name {
            nameTextField.text = name
        }
        
        if let email = Model.model.currentUser?.email{
            emailTextField.text = email
        }
    }
    
    func setupRecognizers(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func screenTapped(){
        delegate?.cancelled()
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = false
    }
    
    func setupButton(){
        saveButton.layer.cornerRadius = 10
        saveButton.layer.masksToBounds = false
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.cancelled()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        guard nameTextField.text != "" else{
            UIView.animate(withDuration: 0.25, animations: {
                self.nameValidationLabel.isHidden = false
            })
            return
        }
        
        guard emailTextField.text != "" else {
            UIView.animate(withDuration: 0.25, animations: {
                self.emailTextField.isHidden = false
            })
            return
        }
        
        let newName = nameTextField.text!.strip()
        let newEmail = emailTextField.text!.strip()
        
        Model.model.updateUser(name: newName, email: newEmail){ [unowned self] (success) in
            self.delegate?.accountUpdated()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else{
            return
        }
        
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else{
            return
        }
        
        oldFrame = cardView.frame
        let remainingScreen = view.frame.height - keyboardSize.height
        
        if cardView.frame.maxY > remainingScreen{
            let difference = cardView.frame.maxY - remainingScreen
            var newFrame = CGRect()
            
            if cardView.frame.height > remainingScreen{ // If the card height is bigger than the available screen after the keyboard shows, then modify
                let newHeight = remainingScreen - 2 * padding
                newFrame = CGRect(x: oldFrame!.origin.x, y: padding, width: oldFrame!.width, height: newHeight)
                
            }else{ // Of not, just shift the card up
                newFrame = CGRect(x: oldFrame!.origin.x, y: oldFrame!.origin.y - difference - padding, width: oldFrame!.width, height: oldFrame!.height)
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.cardView.frame = newFrame
            })
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let frame = oldFrame else{
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
        
        switch textField {
        case nameTextField:
            
            if let text = nameTextField.text, !text.isEmpty {
                UIView.animate(withDuration: 0.25, animations: {
                    self.nameValidationLabel.isHidden = true
                    self.emailTextField.becomeFirstResponder()
                })
                
                return true
            }else{
                UIView.animate(withDuration: 0.25, animations: {
                    self.nameValidationLabel.isHidden = false
                })
                return false
            }
            
        default:
            if let text = emailTextField.text, !text.isEmpty {
                UIView.animate(withDuration: 0.25, animations: {
                    self.emailValidationLabel.isHidden = true
                    self.emailTextField.resignFirstResponder()
                })
                
                return true
            }else{
                UIView.animate(withDuration: 0.25, animations: {
                    self.emailValidationLabel.isHidden = false
                })
                return false
            }
        }
    }
}
