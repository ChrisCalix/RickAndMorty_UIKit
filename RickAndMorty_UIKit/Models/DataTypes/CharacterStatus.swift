//
//  CharacterStatus.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import Foundation

enum CharacterStatus: String, Codable {
    
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}
