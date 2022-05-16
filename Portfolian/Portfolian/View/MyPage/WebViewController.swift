//
//  Auth42APIViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2022/04/29.
//

import UIKit
import WebKit

class WebViewController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var url: URL!
    var reportCode: ((String)->Void)?
    
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    internal func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: view.frame.midX-50, y: view.frame.midY-50, width: 100, height: 100)
        activityIndicator.color = ColorPortfolian.thema
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
}
