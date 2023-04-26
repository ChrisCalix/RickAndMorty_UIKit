//
//  NoSearchResultsView.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import UIKit

final class NoSearchResultsView: UIView {
    
    private let viewModel = NoSearchResultsViewViewModel()
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .secondaryLabel
        return iconView
    }()
    private let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(iconView, label)
        addConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    func addConstraints() {
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 90),
            iconView.heightAnchor.constraint(equalToConstant: 90),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10)
        ])
    }
    
    public func configure() {
        
        label.text = viewModel.title
        iconView.image = viewModel.image
    }
}
