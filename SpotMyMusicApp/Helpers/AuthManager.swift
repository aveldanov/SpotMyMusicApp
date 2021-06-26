//
//  AuthManager.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
//

import Foundation


final class AuthManager{
    static let shared = AuthManager()
    
    
    struct Constants {
        static let clientID = "cab2989e12fa45e69f28440e52f53172"
        static let clientSecret = "67a4973e4394471a86ca3da29a4a4734"
    }
    
    
    private init(){}
    
    var isSignedIn: Bool{
        return false
    }
    
    public var signInURL: URL?{
        let scope = "user-read-private"
        let baseURLSting = "https://accounts.spotify.com/authorize"
        let redirectURI = "https://www.intuit.com/"
        let urlString = "\(baseURLSting)?response_type=code&client_id=\(Constants.clientID)&scope=\(scope)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: urlString)
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
    
    private var shouldRefreshToken: Bool{
        return false
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool)->(Void))){
        //Get token
    }
    
    public func refreshAccessToken(){
        
    }
    
    public func cacheToken(){
        
        
    }
}
