//
//  RecommendationsResponse.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/7/21.
//

import Foundation


struct RecommendationsResponse: Codable {
    let track: [AudioTrack]
}

struct AudioTrack: Codable{
    let album: Album
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String

}
