//
//  CharacterInfoCollectionViewCell.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import UIKit

class CharacterInfoCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    public func configure(with viewModel: CharacterInfoCollectionViewCellViewModel) {
        
    }
}
