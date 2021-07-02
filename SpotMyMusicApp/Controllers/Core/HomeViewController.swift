//
//  ViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        
        //settings button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
        fetchData()
        
    }
    
    private func fetchData(){
        APICaller.shared.getNewReleases { result in
            switch result{
            case .success(let model):
                break //for now
            case .failure(let error):
                break // fpr now
            }
        }
        
        APICaller.shared.getFeaturedPlaylists{ result in
            switch result{
            case .success(let model):
                break //for now
            case .failure(let error):
                break // fpr now
            }
        }
        
        
        APICaller.shared.getRecommendedGenres{ result in
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count <= 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { _ in
                    
                }
                
            case .failure(let error):
                break // fpr now
            }
        }
        
    }
    
    
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

