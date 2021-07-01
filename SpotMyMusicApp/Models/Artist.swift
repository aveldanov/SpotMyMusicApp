//
//  Artist.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/26/21.
//

import Foundation


struct Artist: Codable {
    let name: String
    let id: String
    let external_urls: [String:String]
    let type: String
}
