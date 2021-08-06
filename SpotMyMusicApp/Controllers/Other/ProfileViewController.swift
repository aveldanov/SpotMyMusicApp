//
//  ProfileViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        fetchProfile()
    }
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { result in
            print("result",result)
            DispatchQueue.main.async {
                self.failedToGetProfile()
//                switch result{
//                case .success(let model):
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    self.failedToGetProfile()
//                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile){
        
        
    }
    
    
    private func failedToGetProfile(){
        print("YO")
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
}
