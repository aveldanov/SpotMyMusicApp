//
//  AuthManager.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import Foundation


final class AuthManager{
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "cab2989e12fa45e69f28440e52f53172"
        static let clientSecret = "67a4973e4394471a86ca3da29a4a4734"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.intuit.com/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        
        
    }
    
    
    private init() {}
    
    
    public var signInURL: URL?{
        let baseURL = "https://accounts.spotify.com/authorize"
        let stringURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: stringURL)
    }
    
    var isSignedIn: Bool{
        return accessToken != nil
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool{
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        //if currentDate + 5 min >= expirationDate then REFRESH
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
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
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            completion(false)
            print("Error getting base64")
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        print("BASE",base64String)
        
        
        // API request
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            
            do{
                //                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                
                //                print("SUCCESS", json)
                completion(true)
                
            }catch{
                print(error.localizedDescription)
                completion(false)
                
            }
            
            
        }.resume()
        
    }
    
    //array of escaping closures
    private var onRefreshBlocks = [(String)->Void]()
    
    // Supplies a valid token with API calls
    public func withValidToken(completion: @escaping (String)->Void){
        guard !refreshingToken else {
            // Append the completion to check for redundunt refresh calls
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken{
            //refresh
            refreshTokenIfNeeded { success in
                if let token = self.accessToken, success{
                    completion(token)
                }
            }
        }else if let token = accessToken{
            completion(token)
        }
    }
    
    public func refreshTokenIfNeeded(completion: @escaping ((Bool)->Void)){
        // prevents from refreshing in case refreshing is already in progress
        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        //MARK: Refresh the token
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            completion(false)
            print("Error getting base64")
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        print("BASE",base64String)
        
        
        // API request
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.refreshingToken = false
            
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            
            do{
                
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed", result)
                self.onRefreshBlocks.forEach{$0(result.access_token)}
                self.onRefreshBlocks.removeAll()
                self.cacheToken(result: result)
                
                //                print("SUCCESS", json)
                completion(true)
                
            }catch{
                print(error.localizedDescription)
                completion(false)
                
            }
            
            
        }.resume()
        
    }
    
    public func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)  ), forKey: "expirationDate")
        
    }
    
    
}
