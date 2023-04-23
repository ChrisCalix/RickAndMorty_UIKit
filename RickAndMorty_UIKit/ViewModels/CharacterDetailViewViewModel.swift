//
//  CharacterDetailViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import Foundation

/// View Model to handle character list view logic
final class CharacterDetailViewViewModel {
    
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    
    private let character: Character
    public let sections = SectionType.allCases
    public var title: String {
        character.name.uppercased()
    }
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
//MARK: Init
    init(character: Character) {
        
        self.character = character
    }
}
