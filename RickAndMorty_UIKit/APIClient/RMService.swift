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
    
    private let cacheManager = APICacheManager()
    
    enum RMServiceError: Error {
        
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    ///   - type: Type of objects expect to get back
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        if let cachedData = cacheManager.cacheResponse(for: request.endpoint, url: request.url) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                print("Using cached API")
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: Privete
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
