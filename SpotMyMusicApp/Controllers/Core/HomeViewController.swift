//
//  ViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var collecitonView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, environment in
        
        return createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        
        return spinner
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
        
        // environment - iPad, iPhone etc - ignoring for now
        view.addSubview(spinner)
        
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collecitonView.frame = view.bounds
    }
    
    
    private func configureCollectionView(){
        view.addSubview(collecitonView)
        collecitonView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collecitonView.dataSource = self
        collecitonView.delegate = self
        collecitonView.backgroundColor = .systemBackground
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        // Create Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
        )
        
        // Put in the Group
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)),
            subitem: item,
            count: 1)
        
        // Section
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    
    private func fetchData(){
        // Featured Playlists
        // Recommended Tracks
        // Get New Releases
        
        
        //        APICaller.shared.getNewReleases { result in
        //            switch result{
        //            case .success(let model):
        //                break
        //            case .failure(let error):
        //                break
        //            }
        //        }
        
        
        //        APICaller.shared.getFeaturedPlaylist() { result in
        //            switch result{
        //            case .success(let model):
        //                break
        //            case .failure(let error):
        //                break
        //            }
        //        }
        
        //        APICaller.shared.getRecommendations() { _ in
        //
        //        }
        
        APICaller.shared.getRecommendedGenres { result in
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { result in
                    
                }
                
                
            case .failure(let error): break
                
                
                
            }
        }
        
        
        
    }
    
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .systemPink
        return cell
    }
    
    
    
}
