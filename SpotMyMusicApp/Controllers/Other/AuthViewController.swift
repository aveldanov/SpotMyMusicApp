//
//  AuthViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    //anounimouse closure
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        config.defaultWebpagePreferences = pref
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SignIn"
        view.backgroundColor = .systemBackground
    }
    


}
