//
//  CharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import Foundation

final class CharacterEpisodeCollectionViewCellViewModel {
    
    private let episodeDataUrl: URL?
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
}
