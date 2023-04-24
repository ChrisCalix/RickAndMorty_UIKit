//
//  EpisodeDetailViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 24/4/23.
//

import Foundation

final class EpisodeDetailViewViewModel {
    
    private let endpoint: URL?
    
    init(endpoint: URL?) {
        self.endpoint = endpoint
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        
        guard let url = endpoint, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: Episode.self) { result in
            
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
}
