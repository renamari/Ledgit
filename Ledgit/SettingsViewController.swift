//
//  SettingsViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz2 on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

struct SettingsContent {
    var name: String
    var icon: UIImage
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet var separator: UIView!
    private var presenter = SettingsPresenter(manager: SettingsManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupPresenter()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .white
    }

    func setupView() {
        if LedgitUser.current.subscription == .free {
            signoutButton.isHidden = true
            separator.isHidden = true
        } else {
            signoutButton.isHidden = false
            separator.isHidden = false
        }
    }

    func setupPresenter() {
        presenter.delegate = self
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signoutButtonPressed(_ sender: Any) {
        presenter.signout()
    }

    @IBAction func categoriesButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.category, sender: self)
    }

    @IBAction func subscriptionButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.subscription, sender: self)
    }

    @IBAction func accountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.account, sender: self)
    }

    @IBAction func abountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.about, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier

        switch identifier {
        case Constants.SegueIdentifiers.account:
            guard let accountViewController = segue.destination as? AccountViewController else { return }
            accountViewController.presenter = presenter

        case Constants.SegueIdentifiers.subscription:
            break

        case Constants.SegueIdentifiers.category:
            guard let categoriesViewController = segue.destination as? CategoriesViewController else { return }
            categoriesViewController.presenter = presenter

        default: break
        }
    }
}

extension SettingsViewController: SettingsPresenterDelegate {
    func signedout() {
        let navigationController = MainNavigationController.instantiate(from: .main)
        present(navigationController, animated: true, completion: nil)
    }
}
