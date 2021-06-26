//
//  AuthViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let prefs = WKWebpagePreferences()
        // allow to use JavaScript
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
    }
    
    
    


}
