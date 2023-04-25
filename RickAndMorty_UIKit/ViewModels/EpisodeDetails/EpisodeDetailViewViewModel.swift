//
//  EpisodeDetailViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 24/4/23.
//

import Foundation

protocol EpisodeDetailViewViewModelDelegate: AnyObject {
    
    func didFetchEpisodeDetails()
}

final class EpisodeDetailViewViewModel {
    
    enum SectionType {
        case information(viewModels: [EpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [CharacterEpisodeCollectionViewCellViewModel])
    }
    
    private let endpoint: URL?
    private var dataTupple: (Episode, [Character])? {
        didSet {
            delegate?.didFetchEpisodeDetails()
        }
    }
    public weak var delegate: EpisodeDetailViewViewModelDelegate?
    ///  thsi property is public but only get. bcause the set is declarated as private access
    public private(set) var sections = [SectionType]()
    
    init(endpoint: URL?) {
        
        self.endpoint = endpoint
    }
    
    public func fetchEpisodeData() {
        
        guard let url = endpoint, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: Episode.self) { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: Episode) {
        
        let requests: [RMRequest] = episode.characters.compactMap({ urlString in
            return URL(string: urlString)
        }).compactMap({ url in
            return RMRequest(url: url)
        })
        
        let group = DispatchGroup()
        var characters = [Character]()
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: Character.self) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            
            self.dataTupple = (
                episode, characters
            )
        }
    }
}
