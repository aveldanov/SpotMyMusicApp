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
    
    private var shouldRefreshToken: Bool?{
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
            URLQueryItem(name: "redirect_uri", value: "https://www.intuit.com/")
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
    
    public func refreshTokenIfNeeded(completion: @escaping ((Bool)->Void)){
        guard let shouldRefresh = shouldRefreshToken else {
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
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            
            do{

                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed")
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
