//
//  CharacterDetailViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import Foundation

/// View Model to handle character list view logic
final class CharacterDetailViewViewModel {
    
    private let character: Character
    public var title: String {
        character.name.uppercased()
    }
    
    init(character: Character) {
        
        self.character = character
    }
}
