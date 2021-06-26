//
//  WelcomeViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SpotMyMusic"
        view.backgroundColor = .systemGreen
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    
    func signInButtonClicked(){
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        
        
        
    }
}
