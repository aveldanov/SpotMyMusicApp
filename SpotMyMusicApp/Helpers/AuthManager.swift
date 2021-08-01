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
        static let cleintID = "cab2989e12fa45e69f28440e52f53172"
        static let clientSecret = "67a4973e4394471a86ca3da29a4a4734"
    }
    
    
    private init() {}
    
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
    
}
