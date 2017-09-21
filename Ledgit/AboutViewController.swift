//
//  AboutViewController.swift
//  Ledgit
//
//  Created by Camden Madina on 8/21/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
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
        
        setupWebView()
        
        setupButton()
    }
    
    func setupButton(){
        backButton.layer.cornerRadius = backButton.frame.height / 2
        backButton.layer.masksToBounds = true
        backButton.clipsToBounds = true
    }
    
    func setupWebView(){
        webView.delegate = self
        
        let request = URLRequest(url: URL(string: "http://camden-developers.weebly.com")!)
        
        webView.loadRequest(request)
    }

    @IBAction func returnpage(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
    }
}

extension AboutViewController: UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        isLoading = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        isLoading = false
    }
}
