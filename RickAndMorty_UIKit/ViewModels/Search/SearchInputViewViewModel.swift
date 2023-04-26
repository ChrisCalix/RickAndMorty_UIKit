//
//  SearchInputViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import Foundation

final class SearchInputViewViewModel {
    
    enum DynamicOption: String {
        
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
    }
    
    private let type: SearchViewController.Config.`Type`
    public var hasDynamicOptions: Bool {
        switch self.type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }
    public var options: [DynamicOption] {
        switch type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }
    public var searchPlaceHolderText: String {
        switch type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Title"
        }
    }
    
    init(type: SearchViewController.Config.`Type`) {
        
        self.type = type
    }
    
    
}
