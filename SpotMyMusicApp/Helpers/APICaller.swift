//
//  APICaller.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    private init(){}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1/me" // from API page
    }
    
    enum APIError: Error{
        case failedToGetData
        
    }
    
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile,Error>)->(Void)){
        
        createRequest(with: URL(string: Constants.baseAPIURL+"/me"), type: .GET) { baseRequest in
            URLSession.shared.dataTask(with: baseRequest) { data, response, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    
                    let result = JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                }catch{
                    
                    completion(.failure(error))
                    
                }
                
                
            }
        }
    }
    
    enum HttpMethod: String{
        case GET
        case POST
        
        
    }
    
    private func createRequest(
        with url: URL?,
        type: HttpMethod,
        completion:@escaping (URLRequest)->(Void)
    ){
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else{
                return
            }
            
            var request = URLRequest(url: apiURL)
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
        
        
    }
    
}
