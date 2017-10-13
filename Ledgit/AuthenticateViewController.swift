//
//  AuthenticateViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
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
    
    var method: AuthenticationMethod = .signin
    
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
        // The labels update if the user goes back and selects a different authentication method (login/signup)
        setupLabels()
    }
    
    func setupLabels(){

        switch method{
        case .signup:
            titleLabel.text = Constants.AuthenticateText.signup
            authenticateButton.setTitle("Sign Up", for: .normal)
            descriptionLabel.text = Constants.AuthenticateText.signupDescription
            forgotPasswordButton.isHidden = true
            
        case .signin:
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
        
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func screenTapped(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func authenticateButtonPressed(_ sender: Any) {
        switch method {
        case .signup:
            performFirebaseSignUp()
        case .signin:
            performFirebaseSignIn()
        }
    }
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        switch method {
        case .signup:
            performFacebookSignUp()
        case .signin:
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
        isLoading = true
        
        guard Reachability.isConnectedToNetwork() == true else{
            isLoading = false
            showAlert(with: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        guard let email = emailTextField.text?.strip(), let password = passwordTextField.text?.strip(),
        !email.isEmpty, !password.isEmpty else {
            isLoading = false
            return
        }
        
        Model.model.createUser(with: email, password: password) { (result) in
            self.isLoading = false
            
            switch result{
            case .failed(let code):
                switch code {
                    
                case .emailAlreadyInUse:
                    self.showAlert(with: Constants.AuthErrorMessages.emailAlreadyInUse)
                    
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
                
            case .cancelled:
                break
            }
        }
    }
    
    func performFirebaseSignIn(){
        isLoading = true
        
        guard Reachability.isConnectedToNetwork() == true else{
            isLoading = false
            showAlert(with: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        guard let email = emailTextField.text?.strip(), let password = passwordTextField.text?.strip(),
        !email.isEmpty, !password.isEmpty else {
            isLoading = false
            return
        }
    
        Model.model.authenticateUser(with: email, password: password) { (result) in
            self.isLoading = false
            
            switch result{
            
            case .failed(let code):
                
                switch code {
                    
                case .userDisabled:
                    self.showAlert(with: Constants.AuthErrorMessages.userDisabled)
                    
                case .invalidEmail:
                    self.showAlert(with: Constants.AuthErrorMessages.invalidEmail)
                    
                case .wrongPassword:
                    self.showAlert(with: Constants.AuthErrorMessages.wrongPassword)
                    
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
                
            case .cancelled:
                break
            }
        }
    }
    
    func performFacebookSignUp(){
        isLoading = true
        
        guard Reachability.isConnectedToNetwork() == true else{
            isLoading = false
            showAlert(with: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        guard let email = emailTextField.text?.strip(), let password = passwordTextField.text?.strip(),
        !email.isEmpty, !password.isEmpty else {
            isLoading = false
            return
        }
        
        Model.model.createUser(with: email, password: password) {(result) in
            self.isLoading = false
            
            switch result{
            case .failed(let code):
                switch code {
                    
                case .emailAlreadyInUse:
                    self.showAlert(with: Constants.AuthErrorMessages.emailAlreadyInUse)
                    
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
                
            case .cancelled:
                break
            }
        }
    }
    
    func performFacebookSignIn(){
        isLoading = true
        
        guard Reachability.isConnectedToNetwork() == true else{
            isLoading = false
            showAlert(with: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        guard let email = emailTextField.text?.strip(), let password = passwordTextField.text?.strip(),
        !email.isEmpty, !password.isEmpty else {
            isLoading = false
            return
        }
        
        Model.model.authenticateUserWithFacebook { [unowned self] (result) in
            self.isLoading = false
            
            switch result{
                
            case .failed(let code):
                
                switch code {
                    
                case .userDisabled:
                    self.showAlert(with: Constants.AuthErrorMessages.userDisabled)
                    
                case .invalidEmail:
                    self.showAlert(with: Constants.AuthErrorMessages.invalidEmail)
                    
                case .wrongPassword:
                    self.showAlert(with: Constants.AuthErrorMessages.wrongPassword)
                    
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
