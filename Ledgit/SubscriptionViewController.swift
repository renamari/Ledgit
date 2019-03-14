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
