//
//  CharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import Foundation

final class CharacterPhotoCollectionViewCellViewModel {
    
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return nil
        }
        
        return ImageLoader.shared.downloadImage(url, completion: completion)
    }
}
