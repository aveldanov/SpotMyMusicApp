//
//  Settings.swift
//  SpotMyMusicApp
//
//  Created by Anton Veldanov on 6/27/21.
//

import Foundation


struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: ()->(Void) // closuer
}
