//
//  Artist.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/1/21.
//

import Foundation

struct Artist: Codable{
    let external_urls: [String: String]
    let id: String
    let name: String
    let type: String
}
