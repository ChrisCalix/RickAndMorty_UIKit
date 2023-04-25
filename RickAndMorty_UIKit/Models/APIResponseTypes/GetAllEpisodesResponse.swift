//
//  GetAllEpisodesResponse.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 24/4/23.
//

import Foundation

struct GetAllEpisodesResponse: Codable {
    
    let info: Info
    let results: [Episode]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}


