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
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile,Error>)->(Void)){
        
        
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
