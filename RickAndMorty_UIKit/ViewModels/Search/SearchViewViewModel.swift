//
//  SearchViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import Foundation

/// responsabilities
/// Show search results
/// show no results view
/// kick off API request
final class SearchViewViewModel {
    
    let config: SearchViewController.Config
    private var optionMap = [SearchInputViewViewModel.DynamicOption: String]()
    private var optionMapUpdateBlock:  ((SearchInputViewViewModel.DynamicOption, String) -> Void)?
    private var searchText = String()
    private var searchResultHandler: ((SearchResultViewModel) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var searchResultModel: Codable?

    init(config: SearchViewController.Config) {
        self.config = config
    }
    
    public func set(value: String, for option: SearchInputViewViewModel.DynamicOption) {
        
        optionMap[option] = value
        optionMapUpdateBlock?(option, value)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping (SearchInputViewViewModel.DynamicOption, String) -> Void) {
        
        optionMapUpdateBlock = block
    }
    
    public func executeSearch() {
        
        /// Build arguments
        var queryParams = [URLQueryItem]()
        /// Add options
        queryParams.append(contentsOf: [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))])
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: SearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        /// Create request
        let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParams)
        switch config.type {
        case .character:
            makeSearchapiCall(request: request, GetAllCharactersResponse.self) {[weak self] characters in
                self?.searchResultModel = characters
                let charactersViewModel = characters.results.compactMap({ character in
                    return CharacterCollectionViewCellViewModel(characterId: character.id, characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
                })
                self?.searchResultHandler?(.characters(charactersViewModel: charactersViewModel))
            }
        case .episode:
            makeSearchapiCall(request: request, GetAllEpisodesResponse.self) {[weak self] episodes in
                self?.searchResultModel = episodes
                let episodesViewModel = episodes.results.compactMap({ episode in
                    return CharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url))
                })
                self?.searchResultHandler?(.episodes(episodesViewModel: episodesViewModel))
            }
        case .location:
            makeSearchapiCall(request: request, GetAllLocationsResponse.self){[weak self] locations in
                self?.searchResultModel = locations
                let locationsViewModel = locations.results.compactMap({ location in
                    return LocationTableViewCellViewModel(location: location)
                })
                self?.searchResultHandler?(.locations(locationsViewModel: locationsViewModel))
            }
        }
        /// Notify to the view
    }
    
    private func makeSearchapiCall<T: Codable>(request: RMRequest, _ type: T.Type, completion: @escaping (T) -> Void) {
        
        RMService.shared.execute(request, expecting: type) { result in
            
            switch result {
            case .success(let model):
                completion(model)
            case .failure:
                self.handleNoResults()
            }
        }
    }
    
    private func handleNoResults() {
        
        noResultsHandler?()
    }

    public func set(query text: String) {
        
        self.searchText = text
    }
    
    public func registerSearchResultHandler(_ block: @escaping (SearchResultViewModel) -> Void) {
        
        self.searchResultHandler = block
    }
    
    public func registerNoResultHandler(_ block: @escaping () -> Void) {
        
        self.noResultsHandler = block
    }
    
    public func locationSearchResult(at index: Int) -> Location? {
        
        guard let searchModel = searchResultModel as? GetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    public func episodeSearchResult(at index: Int) -> Episode? {
        
        guard let searchModel = searchResultModel as? GetAllEpisodesResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    public func CharacterSearchResult(at index: Int) -> Character? {
        
        guard let searchModel = searchResultModel as? GetAllCharactersResponse else {
            return nil
        }
        return searchModel.results[index]
    }
}
