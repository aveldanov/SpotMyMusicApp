//
//  AuthManager.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 6/18/21.
//

import Foundation


final class AuthManager{
    static let shared = AuthManager()
    
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
    
}
