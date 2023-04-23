//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import Foundation

final class CharacterCollectionViewCellViewModel {
    
    let characterId: Int
    let characterName: String
    let characterStatus: CharacterStatus
    let characterImageUrl: URL?
    
    //MARK: Init
    init(characterId: Int, characterName: String, characterStatus: CharacterStatus, characterImageUrl: URL?) {
        self.characterId = characterId
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var CharacterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        //TODO: Abstract to Image Manager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return nil
        }
        
        return ImageLoader.shared.downloadImage(url, completion: completion)
    }
}
