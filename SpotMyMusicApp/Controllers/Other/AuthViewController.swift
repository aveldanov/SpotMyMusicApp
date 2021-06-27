//
//  AuthViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let prefs = WKWebpagePreferences()
        // allow to use JavaScript
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completion: ((Bool)->(Void))?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds // fill the entire view
        
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Exchange the code for access token from URL we get from Spotify callbacl url
        
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"
        })?.value else{
            return
        }
        webView.isHidden = true
        print("Code\(code)")
        
        AuthManager.shared.exchangeCodeForToken(code: code) { success in
            
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.completion?(success)
            }

        }
    }


}
