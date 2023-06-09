//
//  CharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import UIKit

protocol EpisodeDataRender {
    
    var air_date: String { get }
    var episode: String { get }
    var name: String { get }
}

final class CharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    
    private let episodeDataUrl: URL?
    private var isFetching: Bool
    private var dataBlock: ((EpisodeDataRender) -> Void)?
    private var episode: Episode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }
    public let borderColor: UIColor

    //MARK: Init
    init(episodeDataUrl: URL?, borderColor: UIColor = UIColor.secondaryLabel) {
        self.borderColor = borderColor
        self.episodeDataUrl = episodeDataUrl
        isFetching = false
    }
    
    public func fetchEpisode() {
        guard !isFetching,
              let url = episodeDataUrl,
              let request = RMRequest(url: url) else {
            guard let episode else { return }
            dataBlock?(episode)
            return
        }
        
        isFetching = true
        RMService.shared.execute(request, expecting: Episode.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                self.episode = model
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    public func registerForData(_ block: @escaping (EpisodeDataRender) -> Void) {
        
        self.dataBlock = block
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: CharacterEpisodeCollectionViewCellViewModel, rhs: CharacterEpisodeCollectionViewCellViewModel) -> Bool {
        
        return lhs.hashValue == rhs.hashValue
    }
}
