//
//  RMService.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    
    /// Shared Singleton instance
    static let shared = RMService()
    
    /// Privaticed Constructor
    private init() { }
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    ///   - type: Type of objects expect to get back
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        
    }
}
