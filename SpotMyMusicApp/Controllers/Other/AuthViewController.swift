//
//  AuthViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    //anounimouse closure
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        config.defaultWebpagePreferences = pref
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    
    // to flag when sign in is over
    public var completionHandler: ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SignIn"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
    }
    
    // load up URL for sign in
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.frame
    }

}
