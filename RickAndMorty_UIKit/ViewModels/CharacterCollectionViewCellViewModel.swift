//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import Foundation

final class CharacterCollectionViewCellViewModel {
    
    let characterName: String
    let characterStatus: CharacterStatus
    let characterImageUrl: URL?
    
    //MARK: Init
    init(characterName: String, characterStatus: CharacterStatus, characterImageUrl: URL?) {
        
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var CharacterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        //TODO: Abstract to Image Manager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
