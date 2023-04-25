//
//  EpisodeInfoCollectionViewCell.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 24/4/23.
//

import UIKit

final class EpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: EpisodeInfoCollectionViewCellViewModel) {
        
    }
}
