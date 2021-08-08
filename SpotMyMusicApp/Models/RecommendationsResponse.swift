//
//  RecommendationsResponse.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 8/7/21.
//

import Foundation


struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}

