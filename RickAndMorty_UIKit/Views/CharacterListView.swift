//
//  CharacterListView.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import UIKit

protocol CharacterListViewDelegate: AnyObject {
    
    func characterListView(_ characterListView: CharacterListView, didSelect character: Character)
}

/// View that handles showing lst of characters, loader, etc.
final class CharacterListView: UIView {
    
    public weak var delegate: CharacterListViewDelegate?
    private let viewModel = CharacterListViewViewModel()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        collectionView.register(FooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraint()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchCharacters()
        setupCollectionView()
    }
    
    required init? (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addConstraint() {
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension CharacterListView: CharacterListViewViewModelDelegate {
    
    func didLoadInitialCharacters() {
        
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() //Initial page
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreCharacters(with indexPaths: [IndexPath]) {
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    func didSelectCharacter(_ character: Character) {
        
        delegate?.characterListView(self, didSelect: character)
    }
}
