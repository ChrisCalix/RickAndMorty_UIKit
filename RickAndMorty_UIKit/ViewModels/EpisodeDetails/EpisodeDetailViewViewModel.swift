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
        case information(viewModels: [InfoCollectionViewCellViewModel])
        case characters(viewModels: [CharacterCollectionViewCellViewModel])
    }
    
    private let endpoint: URL?
    private var dataTupple: (episode: Episode, characters: [Character])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    public weak var delegate: EpisodeDetailViewViewModelDelegate?
    ///  thsi property is public but only get. bcause the set is declarated as private access
    public private(set) var cellViewModels = [SectionType]()
    
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
    
    public func character(at index: Int) -> Character? {
        
        guard let dataTupple else { return nil }
        return dataTupple.characters[index]
    }
    
    private func createCellViewModels() {
        guard let dataTupple else { return }
        
        let episode = dataTupple.episode
        let characters = dataTupple.characters
        let createdString = episode.created.toDateFormat()?.toShortFormatter() ?? episode.created
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return CharacterCollectionViewCellViewModel(
                    characterId: character.id,
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
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
            self.dataTupple = ( episode: episode, characters: characters)
        }
    }
}
