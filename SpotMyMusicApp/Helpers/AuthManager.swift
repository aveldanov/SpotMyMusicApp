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
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://www.intuit.com/")
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            completion(false)
            print("Error getting base64")
            return
        }
        
        request.setValue("Authorization", forHTTPHeaderField: "Basic \(base64String)")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS",json)
            }catch{
                print(error.localizedDescription)
                completion(false)
                
            }
            
            
        }.resume()
        
    }
    
    public func refreshAccessToken(){
        
    }
    
    public func cacheToken(){
        
    }
    
    
}
