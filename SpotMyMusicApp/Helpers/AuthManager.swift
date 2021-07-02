//
//  AuthManager.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
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
        static let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    
    private init(){}
    
    public var signInURL: URL?{
        let baseURLSting = "https://accounts.spotify.com/authorize"
        let urlString = "\(baseURLSting)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: urlString)
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
        // 5 mins before expiration a token will be refreshed
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool)->(Void))){
        //Get token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        // POST components
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            completion(false)
            print("Base64 problems")
            return
        }
        
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                print("[AuthManager] SUCCESS",result)
                completion(true)
            }catch{
                print("URL Session Failure",error.localizedDescription)
                completion(false)
            }
            
            
        }.resume()
        
    }
    
    
    private var onRefreshBlocks = [(String)->(Void)]()
    
    /// Supplies a valid token to be use with API calls
    public func withValidToken(completion: @escaping (String)->(Void)){
        guard !refreshingToken else {
            //append the completion...to wait
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken{
            //Refresh
            refreshTokenIfNeeded { success in
                if let token = self.accessToken, success{
                    completion(token)
                }
            }
        }else if let token = accessToken{
            print("[AuthManager] TOKEN: ",token)
            completion(token)
        }
    }
    
    
    
    
    public func refreshTokenIfNeeded(completion: ((Bool)->(Void))? ){
        // checking if it is currently being refreshed
        guard !refreshingToken else {
            return
        }
        
        
        // comment for forced refresh - testing
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // refresh the token
        
        //Get token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        
        refreshingToken = true
        
        
        // POST components
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            completion?(false)
            print("Base64 problems")
            return
        }
        
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Success Refresh Token")
                // executing a completion from the array of completions
                self.onRefreshBlocks.forEach{$0(result.access_token)}
                self.onRefreshBlocks.removeAll()
                self.cacheToken(result: result)
                
                print("SUCCESS",result)
                
                completion?(true)
                
            }catch{
                
                print("URL Session Failure",error.localizedDescription)
                completion?(false)
            }
        }.resume() 
    }
    
    public func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        // cash only if refreshed
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        // time logged in + when its expires
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        
    }
}
