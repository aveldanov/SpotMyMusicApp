//
//  APICaller.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import Foundation


final class APICaller{
    static let shared = APICaller()
    private init(){} //This prevents others from using the default '()' initializer for this class. no one can create: let foo = APICaller()
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        
        AuthManager.shared.withValidToken { token in
            <#code#>
        }
    }
    
     //MARK: Generic request for regular API Call
    
    
    private createRequest()-> URLRequest{
        
    }
    
    
    
}

