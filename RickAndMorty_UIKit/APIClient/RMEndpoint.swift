//
//  RMEndpoint.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import Foundation

/// Represent unique API endpoint
@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    /// Endpoint to get character info
    case character
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
