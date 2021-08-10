//
//  ViewController.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21
//

import UIKit

enum BrowserSectionType{
    case newReleases(viewModels: [NewReleasesCellViewModel]) // 1
    case featuredPlaylists(viewModels: [NewReleasesCellViewModel]) //2
    case recommendedTracks(viewModels: [NewReleasesCellViewModel]) //3
}

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
    
    
    private var sections = [BrowserSectionType]()
    
    
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
        
        configureCollectionView()
        view.addSubview(spinner)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collecitonView.frame = view.bounds
    }
    
    
    private func configureCollectionView(){
        view.addSubview(collecitonView)
        
        collecitonView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collecitonView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collecitonView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collecitonView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collecitonView.dataSource = self
        collecitonView.delegate = self
        collecitonView.backgroundColor = .systemBackground
    }
    
    
    
    private func fetchData(){
        // we need to wait for all API responses...DispatchGroup then
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        // Get New Releases
        
        APICaller.shared.getNewReleases { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        // Featured Playlists
        
        APICaller.shared.getFeaturedPlaylist() { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        // Recommended Tracks
        
        APICaller.shared.getRecommendedGenres { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer{
                        group.leave()
                    }
                    switch recommendedResult{
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        // when group.enter() count == group.leave() meaning all async calls done we NOTIFY on the main thread and execute the next step
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks
                  else{
                return
            }
            
            self.configureModels(
                newAlbums: newAlbums,
                playlists: playlists,
                tracks: tracks)
            
        }
    }
    
    
    private func configureModels(
        newAlbums: [Album],
        playlists:[Playlist],
        tracks: [AudioTrack]){
        
        //Configure Models
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylists(viewModels: []))
        sections.append(.recommendedTracks(viewModels: []))
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
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0{
            cell.backgroundColor = .systemGreen
        }else if indexPath.section == 1{
            cell.backgroundColor = .systemPink
        }else if indexPath.section == 2{
            cell.backgroundColor = .systemBlue
        }
        
        
        return cell
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        switch section {
        case 0:
            //1. Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            // space between items
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //2. Put in the Group
            //Vertical group inside of a horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)),
                subitem: item,
                count: 3)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)),
                subitem: verticalGroup,
                count: 1)
            
            //3. Section
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
            
        case 1:
            //1. Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200))
            )
            // space between items
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //2. Put in the Group
            //            Vertical group inside of a horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)),
                subitem: item,
                count: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)),
                subitem: verticalGroup,
                count: 1)
            
            //3. Section
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
            
        case 2:
            //1. Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            // space between items
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //2. Put in the Group
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)),
                subitem: item,
                count: 1)
            
            
            //3. Section
            
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        default:
            //1. Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            // space between items
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //2. Put in the Group
            //Vertical group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)),
                subitem: item,
                count: 1)
            
            //3. Section
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
}
