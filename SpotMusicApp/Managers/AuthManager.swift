//
//  AuthManager.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 6/18/21.
//

import Foundation


final class AuthManager{
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "0ede0bdb97c045709c2263c711d8204b"
        static let clietnKey = "87de4047c0524fcb92dbea08ea1355cd"
    }
    
    
    private init(){}
    
    
    var isSignedIn: Bool{
        return false
    }
    
    private var accessToken: String?{
        return nil
    }
    
    private var refreshToken: String?{
        return nil
    }
    
    private var expirationDate: Date?{
        return nil
    }
    
    private var shouldRefreshToken: Bool{
        return false
    }
    
}
