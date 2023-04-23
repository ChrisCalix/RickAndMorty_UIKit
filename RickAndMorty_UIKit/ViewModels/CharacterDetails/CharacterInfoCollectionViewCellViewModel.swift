//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import Foundation

final class CharacterInfoCollectionViewCellViewModel {
    
    public let value: String
    public let title: String
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
