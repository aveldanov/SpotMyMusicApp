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
                    print(result)
                    
                }catch{
                    print(error.localizedDescription)
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

