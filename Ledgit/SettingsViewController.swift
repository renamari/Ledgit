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
    var actionViewBackground:UIView?
    var actionViewTag = 12345
    
    fileprivate(set) lazy var settingsImages:[UIImage] = {
        return [#imageLiteral(resourceName: "categories-icon"),#imageLiteral(resourceName: "subscription-icon"),#imageLiteral(resourceName: "account-icon"), #imageLiteral(resourceName: "about-icon")]
    }()
    
    fileprivate(set) lazy var settingsTitleText:[String] = {
        return ["Categories","Subscription","Account", "About"]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    func setupTableView(){
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signoutButtonPressed(_ sender: Any) {
        Service.shared.signout { [unowned self] (result) in
            switch result{
            case .success:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.NavigationIdentifiers.main) as! UINavigationController
                
                self.present(navigationController, animated: true, completion: nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == Constants.SegueIdentifiers.account{
            UIView.animate(withDuration: 0.25, animations: {
                self.actionViewBackground = UIView(frame: self.view.frame)
                self.actionViewBackground?.alpha = 0.7
                self.actionViewBackground?.backgroundColor = .black
                self.actionViewBackground?.tag = self.actionViewTag
                self.view.addSubview(self.actionViewBackground!)
            })
            
            if let accountViewController = segue.destination as? AccountViewController{
                accountViewController.delegate = self
            }
        }
        
        if segue.identifier == Constants.SegueIdentifiers.subscription{
            UIView.animate(withDuration: 0.25, animations: {
                self.actionViewBackground = UIView(frame: self.view.frame)
                self.actionViewBackground?.alpha = 0.7
                self.actionViewBackground?.backgroundColor = .black
                self.actionViewBackground?.tag = self.actionViewTag
                self.view.addSubview(self.actionViewBackground!)
            })
        }
    }
}

extension SettingsViewController: AccountActionDelegate{
    func dismissAnimation(){
        if let actionView = view.viewWithTag(actionViewTag){
            UIView.animate(withDuration: 0.45, animations: {
                actionView.alpha = 0
            }, completion: { (successful) in
                if successful{
                    actionView.removeFromSuperview()
                }
            })
        }
    }
    
    func accountUpdated() {
        dismissAnimation()
    }
    
    func cancelled() {
        dismissAnimation()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
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
