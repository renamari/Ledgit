//
//  SubscriptionViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/23/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import WebKit

class SubscriptionViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    func setupWebView() {
        webView.navigationDelegate = self

        guard let requestURL = URL(string: "https://cash.me/$marcosortiz") else {
            dismiss(animated: true, completion: nil)
            return
        }

        let request = URLRequest(url: requestURL)

        webView.load(request)
    }
}

extension SubscriptionViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startLoading()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopLoading()
    }
}
