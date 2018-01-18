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
    
    var presenter: AuthenticationPresenter?
    
    var isLoading:Bool = false {
        didSet {
            switch isLoading {
            case true:
                startLoading()
            case false:
                stopLoading()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecognizers()
        setupTextFields()
        setupPresenter()
        setupButtons()
        setupLabels()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // The labels update if the user goes back and selects a different authentication method (login/signup)
        setupLabels()
    }
    
    func setupPresenter() {
        presenter = AuthenticationPresenter(manager: AuthenticationManager())
        presenter?.delegate = self
    }
    
    func setupLabels() {

        switch method {
        case .signup:
            titleLabel.text = Constants.authenticateText.signup
            authenticateButton.setTitle("Sign Up", for: .normal)
            descriptionLabel.text = Constants.authenticateText.signupDescription
            forgotPasswordButton.isHidden = true
            
        case .signin:
            titleLabel.text = Constants.authenticateText.signin
            authenticateButton.setTitle("Sign In", for: .normal)
            descriptionLabel.text = Constants.authenticateText.signinDescription
            forgotPasswordButton.isHidden = false
        }
    }
    
    func setupTextFields(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func setupButtons(){
        authenticateButton.roundedCorners(radius: Constants.cornerRadius.button)
        facebookButton.roundedCorners(radius: Constants.cornerRadius.button)
    }
    
    func setupViews(){
        loginView.roundedCorners(radius: Constants.cornerRadius.button, borderColor: .ledgitSeparatorGray)
    }
    
    func setupRecognizers(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenTapped)))
    }
    
    @objc func screenTapped(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func authenticateButtonPressed(_ sender: Any) {
        isLoading = true
        
        guard let email = emailTextField.text?.strip() else { return }
        guard let password = passwordTextField.text?.strip() else { return }
        
        presenter?.authenticateUser(platform: .firebase, method: method, email: email, password: password)
    }
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        isLoading = true
        
        guard let email = emailTextField.text?.strip() else { return }
        guard let password = passwordTextField.text?.strip() else { return }
        
        presenter?.authenticateUser(platform: .facebook, method: method, email: email, password: password)
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        print("Forgot Password")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension AuthenticateViewController: AuthenticationPresenterDelegate {
    func successfulAuthentication(of user: LedgitUser) {
        isLoading = false
        LedgitUser.current = user
        
        let navigationController = TripsNavigationController.instantiate(from: .trips)
        present(navigationController, animated: true, completion: nil)
    }
    
    func displayError(_ dict: ErrorDictionary) {
        isLoading = false
        showAlert(with: dict)
    }
}

extension AuthenticateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
