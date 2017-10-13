//
//  AuthenticateViewController.swift
//  Ledgit
//
//  Created by Camden Madina on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate
import NVActivityIndicatorView

class AuthenticateViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var isSignUp:Bool?
    
    var isLoading:Bool = false{
        didSet{
            switch isLoading{
            case true:
                startLoading()
            default:
                stopLoading()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLabels()
        
        setupTextFields()
        
        setupButtons()
        
        setupViews()
        
        setupRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupLabels()
    }
    
    func setupLabels(){
        guard isSignUp != nil else {
            return
        }
        
        switch isSignUp!{
        case true:
            titleLabel.text = Constants.AuthenticateText.signup
            authenticateButton.setTitle("Sign Up", for: .normal)
            descriptionLabel.text = Constants.AuthenticateText.signupDescription
            forgotPasswordButton.isHidden = true
            
        default:
            titleLabel.text = Constants.AuthenticateText.signin
            authenticateButton.setTitle("Sign In", for: .normal)
            descriptionLabel.text = Constants.AuthenticateText.signinDescription
            forgotPasswordButton.isHidden = false
        }
    }
    
    func setupTextFields(){
        emailTextField.delegate = self
    
        passwordTextField.delegate = self
    }
    
    func setupButtons(){
        authenticateButton.createBorder(radius: Constants.CornerRadius.button)
        
        facebookButton.createBorder(radius: Constants.CornerRadius.button)
    }
    
    func setupViews(){
        loginView.createBorder(radius: Constants.CornerRadius.button, color: .kColor9C9C9C)
    }
    
    func setupRecognizers(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func screenTapped(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func authenticateButtonPressed(_ sender: Any) {
        guard isSignUp != nil else {
            return
        }
        
        switch isSignUp! {
        case true:
            performFirebaseSignUp()
        default:
            performFirebaseSignIn()
        }
    }
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        guard isSignUp != nil else {
            return
        }
        
        switch isSignUp! {
        case true:
            performFacebookSignUp()
        default:
            performFacebookSignIn()
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        print("Forgot Password")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func performFirebaseSignUp(){
        guard Reachability.isConnectedToNetwork() == true else{
            showAlert(with: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        isLoading = true
        
        let email = emailTextField.text?.strip()
        let password = passwordTextField.text?.strip()
        
        guard email?.isEmpty == false, password?.isEmpty == false else{
            isLoading = false
            showAlert(with: Constants.ClientErrorMessages.emptyUserPasswordTextFields)
            return
        }
        
        Model.model.createUser(with: email!, password: password!) { (result) in
            self.isLoading = false
            
            switch result{
            case .failed(let code):
                switch code {
                    
                    /** Indicates the user's account is disabled on the server.*/
                case .emailAlreadyInUse:
                    self.showAlert(with: Constants.AuthErrorMessages.emailAlreadyInUse)
                    
                    /** Indicates the email is invalid.*/
                case .invalidEmail:
                    self.showAlert(with: Constants.AuthErrorMessages.invalidEmail)
                    
                default:
                    self.showAlert(with: Constants.AuthErrorMessages.general)
                }
            
            case .success(let user):
                Model.model.currentUser = user
                let storyboard = UIStoryboard(name: "Trips", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.NavigationIdentifiers.trips) as! UINavigationController
                
                self.present(navigationController, animated: true, completion: nil)
                
            default:
                print("Default case")
            }
        }
    }
    
    func performFirebaseSignIn(){
    
        guard Reachability.isConnectedToNetwork() == true else{
            showAlert(with: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        isLoading = true
        
        let email = emailTextField.text?.strip()
        let password = passwordTextField.text?.strip()
        
        guard email?.isEmpty == false, password?.isEmpty == false else{
            isLoading = false
            showAlert(with: Constants.ClientErrorMessages.emptyUserPasswordTextFields)
            return
        }
        
        Model.model.authenticateUser(with: email!, password: password!) { (result) in
            self.isLoading = false
            
            switch result{
            
            case .failed(let code):
                
                switch code {
                    
                    /** Indicates the user's account is disabled on the server.*/
                case .userDisabled:
                    self.showAlert(with: Constants.AuthErrorMessages.userDisabled)
                    
                    /** Indicates the email is invalid.*/
                case .invalidEmail:
                    self.showAlert(with: Constants.AuthErrorMessages.invalidEmail)
                    
                    /** Indicates the user attempted sign in with a wrong password.*/
                case .wrongPassword:
                    self.showAlert(with: Constants.AuthErrorMessages.wrongPassword)
                    
                    /** Indicates the user account was not found.*/
                case .userNotFound:
                    self.showAlert(with: Constants.AuthErrorMessages.userNotFound)
                    
                default:
                    self.showAlert(with: Constants.AuthErrorMessages.general)
                }
                
            case .success(let user):
                Model.model.currentUser = user
                let storyboard = UIStoryboard(name: "Trips", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.NavigationIdentifiers.trips) as! UINavigationController
                
                self.present(navigationController, animated: true, completion: nil)
                
            default:
                //self.addToFirebase()
                print("Default case")
            }
        }
    }
    
    func performFacebookSignUp(){
        guard Reachability.isConnectedToNetwork() == true else{
            showAlert(with: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        isLoading = true
        
        let email = emailTextField.text?.strip()
        let password = passwordTextField.text?.strip()
        
        guard email?.isEmpty == false, password?.isEmpty == false else{
            isLoading = false
            showAlert(with: Constants.ClientErrorMessages.emptyUserPasswordTextFields)
            return
        }
        
        Model.model.createUser(with: email!, password: password!) {(result) in
            self.isLoading = false
            
            switch result{
            case .failed(let code):
                switch code {
                    
                    /** Indicates the user's account is disabled on the server.*/
                case .emailAlreadyInUse:
                    self.showAlert(with: Constants.AuthErrorMessages.emailAlreadyInUse)
                    
                    /** Indicates the email is invalid.*/
                case .invalidEmail:
                    self.showAlert(with: Constants.AuthErrorMessages.invalidEmail)
                    
                default:
                    self.showAlert(with: Constants.AuthErrorMessages.general)
                }
            
            case .success(let user):
                Model.model.currentUser = user
                let storyboard = UIStoryboard(name: "Trips", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.NavigationIdentifiers.trips) as! UINavigationController
                
                self.present(navigationController, animated: true, completion: nil)
                
            default:
                print("Default case")
            }
        }
    }
    
    func performFacebookSignIn(){
        guard Reachability.isConnectedToNetwork() == true else{
            showAlert(with: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        isLoading = true
        
        let email = emailTextField.text?.strip()
        let password = passwordTextField.text?.strip()
        
        guard email?.isEmpty == false, password?.isEmpty == false else{
            isLoading = false
            showAlert(with: Constants.ClientErrorMessages.emptyUserPasswordTextFields)
            return
        }
        
        Model.model.authenticateUserWithFacebook { [unowned self] (result) in
            self.isLoading = false
            
            switch result{
                
            case .failed(let code):
                
                switch code {
                    
                    /** Indicates the user's account is disabled on the server.*/
                case .userDisabled:
                    self.showAlert(with: Constants.AuthErrorMessages.userDisabled)
                    
                    /** Indicates the email is invalid.*/
                case .invalidEmail:
                    self.showAlert(with: Constants.AuthErrorMessages.invalidEmail)
                    
                    /** Indicates the user attempted sign in with a wrong password.*/
                case .wrongPassword:
                    self.showAlert(with: Constants.AuthErrorMessages.wrongPassword)
                    
                    /** Indicates the user account was not found.*/
                case .userNotFound:
                    self.showAlert(with: Constants.AuthErrorMessages.userNotFound)
                    
                default:
                    self.showAlert(with: Constants.AuthErrorMessages.general)
                }
            
            case .success(let user):
                Model.model.currentUser = user
                let storyboard = UIStoryboard(name: "Trips", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.NavigationIdentifiers.trips) as! UINavigationController
                
                self.present(navigationController, animated: true, completion: nil)
            default:
                print("Default case")
            }
        }
    }

    func addToFirebase(){
        /*
        let entry: [String:Any] = [
            "date": Date().toString(withFormat: nil),
            "currency": "USD",
            "location": "Waco",
            "description": "Lunch",
            "category": "Food",
            "paidBy": FIRAuth.auth()?.currentUser!.uid,
            "paymentType": "cash",
            "cost": 13.54,
            "owningTrip": Constants.ProjectID.sample
        ]
        let entry2: [String:Any] = [
            "date": (Date() - 5.days).toString(withFormat: nil),
            "currency": "USD",
            "location": "San Antonio",
            "description": "Lunch",
            "category": "Food",
            "paidBy": FIRAuth.auth()?.currentUser!.uid,
            "paymentType": "cash",
            "cost": 6.99,
            "owningTrip": Constants.ProjectID.sample
        ]
        
        let entry3: [String:Any] = [
            "date": Date().toString(withFormat: nil),
            "currency": "USD",
            "location": "San Antonio",
            "description": "Lunch",
            "category": "Food",
            "paidBy": FIRAuth.auth()?.currentUser!.uid,
            "paymentType": "cash",
            "cost": 14.99,
            "owningTrip": Constants.ProjectID.sample
        ]
        
        Model.model.entries.childByAutoId().setValue(entry)
        Model.model.entries.childByAutoId().setValue(entry2)
        Model.model.entries.childByAutoId().setValue(entry3)
        */
    }
 
}

extension AuthenticateViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
