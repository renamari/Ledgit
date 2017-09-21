//
//  CategoryActionViewController.swift
//  Ledgit
//
//  Created by Camden Madina on 8/24/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

enum Action {
    case add
    case edit
}

protocol CategoryActionDelegate {
    func categoryUpdated(category: String)
    func cancelled()
    func categoryAdded(category:String)
}

class CategoryActionViewController: UIViewController {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    
    var action:Action?
    var category:String?
    var delegate:CategoryActionDelegate?
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
        
        guard action != nil else{
            return
        }
        
        switch action! {
        case .add:
            cardTitleLabel.text = "Add New Category"
        default:
            cardTitleLabel.text = "Edit Category"
            categoryTextField.text = category
        }
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
        categoryTextField.delegate = self
    }
    
    func setupRecognizers(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func screenTapped(){
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
        guard action != nil else{
            return
        }
        
        guard categoryTextField.text != "" else{
            UIView.animate(withDuration: 0.25, animations: {
                self.validationLabel.isHidden = false
            })
            return
        }
        
        let newCategory = categoryTextField.text!.strip()
        
        switch action! {
        case .add:
            
            Model.model.addCategory(category: newCategory, completion: { [unowned self] (success) in
                self.delegate?.categoryAdded(category: newCategory)
                self.dismiss(animated: true, completion: nil)
            })
            
        default:
            Model.model.updateCategory(category: category!, with: newCategory, completion: { [unowned self] (success) in
                self.delegate?.categoryUpdated(category: newCategory)
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func keyboardWillShow(notification: Notification) {
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
    
    func keyboardWillHide(notification: Notification) {
        guard let frame = oldFrame else{
            return
        }
        
        guard categoryTextField.text != "" else {
            return
        }
        
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
        if let text = categoryTextField.text, !text.isEmpty {
            UIView.animate(withDuration: 0.25, animations: { 
                self.validationLabel.isHidden = true
                self.categoryTextField.resignFirstResponder()
            })
        
            return true
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                self.validationLabel.isHidden = false
            })
            return false
        }
    }
}
