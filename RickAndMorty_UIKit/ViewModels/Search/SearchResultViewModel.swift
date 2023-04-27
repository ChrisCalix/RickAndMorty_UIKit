//
//  SearchResultViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 27/4/23.
//

import Foundation

enum SearchResultViewModel {
    
    case characters(charactersViewModel: [CharacterCollectionViewCellViewModel])
    case episodes(episodesViewModel: [CharacterEpisodeCollectionViewCellViewModel])
    case locations(locationsViewModel: [LocationTableViewCellViewModel])
}
