//
//  SettingsViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz2 on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var signoutButton: UIButton!
    let actionViewBackground = UIView()
    let actionViewTag = 12345
    var presenter: SettingsPresenter?
    fileprivate(set) lazy var settingsImages:[UIImage] = {
        return [#imageLiteral(resourceName: "categories-icon"),#imageLiteral(resourceName: "subscription-icon"),#imageLiteral(resourceName: "account-icon"), #imageLiteral(resourceName: "about-icon")]
    }()
    
    fileprivate(set) lazy var settingsTitleText:[String] = {
        return ["Categories","Subscription","Account", "About"]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupPresenter()
    }
    
    func setupPresenter() {
        presenter = SettingsPresenter(manager: SettingsManager())
        presenter?.delegate = self
    }
    
    func setupTableView(){
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signoutButtonPressed(_ sender: Any) {
        presenter?.signout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == Constants.SegueIdentifiers.account {
            guard let accountViewController = segue.destination as? AccountViewController else { return }
            accountViewController.presenter = presenter
        }
        
        if identifier == Constants.SegueIdentifiers.subscription {

        }
        
        if identifier == Constants.SegueIdentifiers.category {
            guard let categoriesViewController = segue.destination as? CategoriesViewController else { return }
            categoriesViewController.presenter = presenter
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //Categories
            performSegue(withIdentifier: Constants.SegueIdentifiers.category, sender: self)
        case 1: //Subscriptions
            performSegue(withIdentifier: Constants.SegueIdentifiers.subscription, sender: self)
        case 2: //Account
            performSegue(withIdentifier: Constants.SegueIdentifiers.account, sender: self)
        default: //About
            performSegue(withIdentifier: Constants.SegueIdentifiers.about, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.settings, for: indexPath) as! SettingsTableViewCell
        
        cell.iconImageView.image = settingsImages[indexPath.row]
        cell.titleLabel.text = settingsTitleText[indexPath.row]
        
        return cell
    }
}

extension SettingsViewController: SettingsPresenterDelegate {
    func signedout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.NavigationIdentifiers.main) as! UINavigationController
        
        self.present(navigationController, animated: true, completion: nil)
    }
}
