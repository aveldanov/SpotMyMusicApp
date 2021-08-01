//
//  WelcomeViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signIntButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SpotMyMusic"
        view.backgroundColor = .systemGreen
        view.addSubview(signIntButton)
        signIntButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signIntButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )
    }
    
    
    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
