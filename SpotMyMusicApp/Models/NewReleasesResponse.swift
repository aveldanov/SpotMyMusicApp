//
//  NewReleasesResponse.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/30/21.
//

import Foundation


struct NewReleasesResponse: Codable {
    let albums: [AlbumsResponse]
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}

struct Artist: Codable {
    let name: String
    let id: String
    let external_urls: [String:String]
    let type: String
}




