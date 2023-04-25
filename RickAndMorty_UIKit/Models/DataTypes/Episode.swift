//
//  Episode.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import Foundation

struct Episode: Codable, EpisodeDataRender {
    
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let created: String
    let url: String
}
