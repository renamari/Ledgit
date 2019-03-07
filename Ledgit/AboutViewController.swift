//
//  AboutViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/21/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    func setupWebView() {
        webView.navigationDelegate = self

        guard let requestURL = URL(string: "https://camden-developers.weebly.com/ledgit.html") else {
            dismiss(animated: true, completion: nil)
            return
        }

        let request = URLRequest(url: requestURL)

        webView.load(request)
    }
}

extension AboutViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startLoading()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopLoading()
    }
}
