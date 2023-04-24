//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import UIKit

class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    public func configure(with viewModel: CharacterEpisodeCollectionViewCellViewModel) {
        
        viewModel.registerForData { data in
            print(data.name)
            print(data.air_date)
            print(data.episode)
        }
        viewModel.fetchEpisode()
    }
}
