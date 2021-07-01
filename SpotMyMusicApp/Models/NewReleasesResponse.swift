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
}




struct Item {
    let item:
}
