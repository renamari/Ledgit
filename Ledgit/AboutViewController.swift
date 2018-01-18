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
    }

    func setupWebView(){
        webView.delegate = self
        
        let request = URLRequest(url: URL(string: "http://camden-developers.weebly.com")!)
        
        webView.loadRequest(request)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
