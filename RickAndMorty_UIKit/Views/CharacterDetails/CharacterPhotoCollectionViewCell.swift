//
//  CharacterPhotoCollectionViewCell.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import UIKit

class CharacterPhotoCollectionViewCell: UICollectionViewCell {
    
    private var imageTask : URLSessionDataTask?
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        imageTask?.cancel()
        imageTask = nil
    }
    
    public func configure(with viewModel: CharacterPhotoCollectionViewCellViewModel) {
        
        imageTask = viewModel.fetchImage {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            case .failure:
                break
            }
        }
    }
}
