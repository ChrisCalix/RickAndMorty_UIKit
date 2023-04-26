//
//  LocationDetailViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import Foundation

protocol LocationDetailViewViewModelDelegate: AnyObject {
    
    func didFetchLocationDetails()
}

final class LocationDetailViewViewModel {
    
    enum SectionType {
        case information(viewModels: [InfoCollectionViewCellViewModel])
        case characters(viewModels: [CharacterCollectionViewCellViewModel])
    }
    
    private let endpoint: URL?
    private var dataTupple: (location: Location, characters: [Character])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    public weak var delegate: LocationDetailViewViewModelDelegate?
    ///  thsi property is public but only get. bcause the set is declarated as private access
    public private(set) var cellViewModels = [SectionType]()
    
    init(endpoint: URL?) {
        
        self.endpoint = endpoint
    }
    
    public func fetchLocationsData() {
        
        guard let url = endpoint, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: Location.self) { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
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
        
        let location = dataTupple.location
        let characters = dataTupple.characters
        let createdString = location.created.toDateFormat()?.toShortFormatter() ?? location.created
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
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
    
    private func fetchRelatedCharacters(location: Location) {
        
        let requests: [RMRequest] = location.residents.compactMap({ urlString in
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
            self.dataTupple = ( location: location, characters: characters)
        }
    }
}
