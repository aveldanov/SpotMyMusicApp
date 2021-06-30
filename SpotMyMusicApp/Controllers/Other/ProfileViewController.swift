//
//  ProfileViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        fetchProfile()
        view.backgroundColor = .systemBackground
    }
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    self.updateUI(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.failedToGetProfile()
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile){
        
        
    }
    
    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed To Load User Profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
}
