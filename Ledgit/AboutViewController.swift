//
//  AboutViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/21/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) { navigationItem.largeTitleDisplayMode = .never }
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if #available(iOS 11.0, *) { navigationItem.largeTitleDisplayMode = .always }
        super.viewWillDisappear(animated)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    func setupWebView() {
        webView.delegate = self
        
        guard let requestURL = URL(string: "http://camden-developers.weebly.com") else {
            doneButtonPressed()
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        webView.loadRequest(request)
    }

    @IBAction func backButtonPressed() {
        webView.goBack()
    }
    
    @IBAction func doneButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension AboutViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) { startLoading() }
    
    func webViewDidFinishLoad(_ webView: UIWebView) { stopLoading() }
}
