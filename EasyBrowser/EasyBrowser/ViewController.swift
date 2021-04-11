//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Reysmer Valle on 4/9/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var selectedSite: String?
    let alertTitle = "Blocked host"
    var message: String!
    var isHostPreLoaded = false
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Go", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, back, forward, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        if let websiteToLoad = selectedSite {
            let url = URL(string: "https://" + websiteToLoad)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
//    @objc func openTapped() {
//        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
//        for website in websites {
//            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
//        }
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//        present(ac, animated: true)
//    }
    
//    func openPage(action: UIAlertAction) {
//        guard let actionTitle = action.title else { return }
//        guard let url = URL(string: "https://" + actionTitle) else { return }
//        webView.load(URLRequest(url: url))
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            message = "\(host) is blocked"
            if let websiteToLoad = selectedSite {
                if host.contains(websiteToLoad) {
                    decisionHandler(.allow)
                    isHostPreLoaded = true
                    return
                } else if host == "reysmerwvr.github.io" {
                    decisionHandler(.allow)
                    isHostPreLoaded = true
                    return
                }
            }
        }
        if isHostPreLoaded {
            decisionHandler(.allow)
            return
        }
        if message != nil {
            showAlert(title: alertTitle, handler: nil, message: message)
        } else {
            showAlert(title: alertTitle, handler: nil, message: alertTitle)
        }
        decisionHandler(.cancel)
    }
    
    func showAlert(title: String, handler: ((UIAlertAction)-> Void)?, message: String = "",
                   style: UIAlertController.Style = .alert, actionStyle: UIAlertAction.Style = .default,
                   actionTitle: String = "Continue", animated: Bool = true) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: handler))
        present(alertController, animated: animated)
    }
}

