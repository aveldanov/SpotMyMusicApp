//
//  WelcomeViewController.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 6/18/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotigy", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SpotMusicApp"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTabSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    func didTabSignIn(){
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
