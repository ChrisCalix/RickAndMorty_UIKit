//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import UIKit

class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        return label
    }()
    
//MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayers()
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayers() {
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: seasonLabel.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: seasonLabel.rightAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leftAnchor.constraint(equalTo: seasonLabel.leftAnchor),
            airDateLabel.rightAnchor.constraint(equalTo: seasonLabel.rightAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    public func configure(with viewModel: CharacterEpisodeCollectionViewCellViewModel) {
        
        viewModel.registerForData { [weak self] data in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.nameLabel.text = data.name
                self.seasonLabel.text = "Episode \(data.episode)"
                self.airDateLabel.text = "Aired on \(data.air_date)"
            }
        }
        viewModel.fetchEpisode()
//        contentView.layer.shadowColor = viewModel.borderColor.cgColor
    }
}
