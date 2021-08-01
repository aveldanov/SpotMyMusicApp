//
//  AuthManager.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import Foundation


final class AuthManager{
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "cab2989e12fa45e69f28440e52f53172"
        static let clientSecret = "67a4973e4394471a86ca3da29a4a4734"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    
    private init() {}
    
    
    public var signInURL: URL?{
        let scopes = "user-read-private"
        let redirectURI = "https://www.intuit.com/"
        let baseURL = "https://accounts.spotify.com/authorize"
        let stringURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: stringURL)
    }
    
    var isSignedIn: Bool{
        return false
    }
    
    private var accessToken: String?{
        return nil
    }
    
    private var refreshToken: String?{
        return nil
    }
    
    private var tokenExpirationDate: Date?{
        return nil
    }
    
    private var shouldRefreshToken: Bool?{
        return false
    }
    
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool)-> Void)){
        // Get token
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            
            
        }.resume()
        
    }
    
    public func refreshAccessToken(){
        
    }
    
    public func cacheToken(){
        
    }
    
    
}
