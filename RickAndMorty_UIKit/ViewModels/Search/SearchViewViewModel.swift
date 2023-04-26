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
    
    init(config: SearchViewController.Config) {
        self.config = config
    }
}
