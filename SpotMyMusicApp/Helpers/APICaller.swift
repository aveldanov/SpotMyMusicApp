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
        AuthManager.shared.withValidToken { token in
            
        }
        
    }
    
    private func createRequest()->URLRequest{
        
        
    }
    
}
