//
//  AuthenticateViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import SwiftDate
import NVActivityIndicatorView

class AuthenticateViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    private var presenter = AuthenticationPresenter(manager: AuthenticationManager())
    var method: AuthenticationMethod = .signin

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
        presenter.delegate = self
    }

    func setupLabels() {

        switch method {
        case .signup:
            titleLabel.text(Constants.AuthenticateText.signup)
            authenticateButton.text("Sign Up")
            forgotPasswordButton.isHidden = true

        case .signin:
            titleLabel.text(Constants.AuthenticateText.signin)
            authenticateButton.text("Sign In")
            forgotPasswordButton.isHidden = false
        }
    }

    func setupTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    func setupButtons() {
        authenticateButton.roundedCorners(radius: Constants.CornerRadius.button)
    }

    func setupViews() {
        loginView.roundedCorners(radius: Constants.CornerRadius.button, borderColor: LedgitColor.separatorGray)
    }

    func setupRecognizers() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenTapped)))
    }

    @objc func screenTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @IBAction func authenticateButtonPressed(_ sender: Any) {
        startLoading()

        guard let email = emailTextField.text?.strip() else { return }
        guard let password = passwordTextField.text?.strip() else { return }

        presenter.authenticateUser(platform: .firebase, method: method, email: email, password: password)
    }

    @IBAction func forgotPasswordButton(_ sender: Any) {
        LedgitLog.info("Forgot password")
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension AuthenticateViewController: AuthenticationPresenterDelegate {
    func successfulAuthentication(of user: LedgitUser) {
        stopLoading()
        LedgitUser.current = user

        let navigationController = TripsNavigationController.instantiate(from: .trips)
        present(navigationController, animated: true, completion: nil)
    }

    func displayError(_ error: LedgitError) {
        stopLoading()
        showAlert(with: error)
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
