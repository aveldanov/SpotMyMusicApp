//
//  APICaller.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import Foundation


final class APICaller{
    static let shared = APICaller()
    private init(){} //This prevents others from using the default '()' initializer for this class. no one can create: let foo = APICaller()
    
    struct Constants{
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error{
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET) { baseRequest in
            
            URLSession.shared.dataTask(with: baseRequest) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                //                print(data)
                do{
                    //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    //                    print(result)
                    completion(.success(result))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }.resume()
        }
        
    }
    
    
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse,Error>)->Void){
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
                
            }.resume()
        }
        
    }
    
    
    public func getFeaturedPlaylist(completion: @escaping (Result<FeaturedPlaylistsResponse,Error>)->Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=2"), type: .GET) { request in
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
                
            }.resume()
            
            
        }
        
    }
    
    
    
    
    public func getRecommendations(genres: Set<String>,completion: @escaping (Result<String,Error>)->Void){
        print("GGGG",genres)

        let seeds = genres.joined(separator: ",")
        print("BOOOM",seeds)
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)"), type: .GET) { request in

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do{

                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
//                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
//                    print(result)
//                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }

            }.resume()
        }

    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse,Error>)->Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
//
//                                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(json)
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
//                    print(result)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
                
            }.resume()
        }
    }
    
    
    
    //MARK: Generic request for regular API Call
    enum HTTPMethod: String{
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?,type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        // URLRequest is URL + HTTPS Params in the call, like header, etc!
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            print(token)
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    
    
}

