//
//  ImageLoader.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import Foundation

final class ImageLoader {
    
    //MARK: Singleton
    static let shared = ImageLoader()
    private init() { }
    
    //MARK: add functionality
    private var imageDataCache = NSCache<NSString, NSData>()
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: source url
    ///   - completion: Callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
