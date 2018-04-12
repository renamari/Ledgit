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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var signoutButton: UIButton!
    private var presenter = SettingsPresenter(manager: SettingsManager())
    fileprivate(set) lazy var settingsContent = [SettingsContent(name: "Categories", icon: #imageLiteral(resourceName: "categories-icon")),
                                                 SettingsContent(name: "Subscription", icon: #imageLiteral(resourceName: "subscription-icon")),
                                                 SettingsContent(name: "Account", icon: #imageLiteral(resourceName: "account-icon")),
                                                 SettingsContent(name: "About", icon: #imageLiteral(resourceName: "about-icon"))]
    
    fileprivate(set) lazy var settingsImages = [#imageLiteral(resourceName: "categories-icon"), #imageLiteral(resourceName: "subscription-icon"), #imageLiteral(resourceName: "account-icon"), #imageLiteral(resourceName: "about-icon")]
    fileprivate(set) lazy var settingsTitleText = ["Categories", "Subscription", "Account", "About"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPresenter()
        setupView()
        setupRecognizers()
    }
    
    func setupView() {
        signoutButton.isHidden = LedgitUser.current.subscription == .free ? true : false
    }
    
    func setupPresenter() {
        presenter.delegate = self
    }
    
    func setupTableView(){
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    func setupRecognizers() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(gesture:)))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc func swipedDown(gesture: UIGestureRecognizer) {
        guard let swipe = gesture as? UISwipeGestureRecognizer else { return }
        swipe.direction == .down ? backButtonPressed(gesture) : nil
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signoutButtonPressed(_ sender: Any) {
        presenter.signout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Constants.segueIdentifiers.account:
            guard let accountViewController = segue.destination as? AccountViewController else { return }
            accountViewController.presenter = presenter
            
        case Constants.segueIdentifiers.subscription:
            break
            
        case Constants.segueIdentifiers.category:
            guard let categoriesViewController = segue.destination as? CategoriesViewController else { return }
            categoriesViewController.presenter = presenter
            
        default: break
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = settingsContent[indexPath.row]
        
        switch content.name {
        case "Categories":
            performSegue(withIdentifier: Constants.segueIdentifiers.category, sender: self)
            
        case "Subscription":
            showAlert(with: Constants.clientErrorMessages.freeSubscriptions)
            //performSegue(withIdentifier: Constants.segueIdentifiers.subscription, sender: self)
            
        case "Account":
            performSegue(withIdentifier: Constants.segueIdentifiers.account, sender: self)
            
        case "About":
            performSegue(withIdentifier: Constants.segueIdentifiers.about, sender: self)
            
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.settings, for: indexPath) as! SettingsTableViewCell
        let content = settingsContent[indexPath.row]
        cell.iconImageView.image(content.icon)
        cell.titleLabel.text(content.name)
        
        return cell
    }
}

extension SettingsViewController: SettingsPresenterDelegate {
    func signedout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.navigationIdentifiers.main) as! UINavigationController
        
        self.present(navigationController, animated: true, completion: nil)
    }
}
