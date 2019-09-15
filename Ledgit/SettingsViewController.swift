//
//  SettingsViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz2 on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import CoreData

struct SettingsContent {
    var name: String
    var icon: UIImage
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet var separator: UIView!
    @IBOutlet var resetButton: UIButton!
    private var presenter = SettingsPresenter(manager: SettingsManager())

    var coreData: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Application Delegate wasn't found. Something went terribly wrong.")
        }

        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupPresenter()
        setupResetButton()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
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

    func setupResetButton() {
        #if DEBUG
        resetButton.isHidden = false
        #endif
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
        showAlert(with: LedgitError.freeSubscriptions)
    }

    @IBAction func accountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.account, sender: self)
    }

    @IBAction func abountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.about, sender: self)
    }

    @IBAction func resetButtonPressed() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)

        let entriesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.LedgitEntity.entry)
        let tripsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.LedgitEntity.trip)
        let entriesDeleteRequest = NSBatchDeleteRequest(fetchRequest: entriesRequest)
        let tripsDeleteRequest = NSBatchDeleteRequest(fetchRequest: tripsRequest)

        do {
            try coreData.execute(entriesDeleteRequest)
            try coreData.execute(tripsDeleteRequest)

        } catch {
            LedgitLog.critical("Couldn't delete all core data")
        }

        presenter.signout()
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
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
