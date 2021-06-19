//
//  AuthViewController.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 6/18/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        
        view.backgroundColor = .systemBackground

    }
    



}
