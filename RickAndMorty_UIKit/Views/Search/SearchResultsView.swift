//
//  SearchResultsView.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 27/4/23.
//

import UIKit

protocol SearchResultsViewDelegate: AnyObject {
    
    func searchResultsView(_ resultView: SearchResultsView, didTapLocationAt index: Int)
}

//final Shows search reslults UI (table or collection as needde
class SearchResultsView: UIView {
    
    weak var delegate: SearchResultsViewDelegate?
    private var viewModel: SearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    private let tableView: UITableView = {
       let tableview = UITableView()
        tableview.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableview.isHidden = true
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier)
        collectionView.register(CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        collectionView.register(FooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    private var locationCellViewModels = [LocationTableViewCellViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var collectionViewCellViewModel: [Any] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, collectionView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func processViewModel() {
        guard let viewModel else { return }
        
        switch viewModel {
        case .characters(let charactersViewModel):
            collectionViewCellViewModel = charactersViewModel
            setupCollectionView()
            break
        case .episodes(let episodesViewModel):
            collectionViewCellViewModel = episodesViewModel
            setupCollectionView()
            break
        case .locations(let locationsViewModel):
            setupTableView(using: locationsViewModel)
            break
        }
    }
    
    private func setupTableView(using locationsViewModel: [LocationTableViewCellViewModel]) {
        
        tableView.delegate = self
        tableView.dataSource = self
        locationCellViewModels = locationsViewModel
        tableView.isHidden = false
        collectionView.isHidden = true
    }
    
    private func setupCollectionView() {
        
        tableView.isHidden = true
        collectionView.isHidden = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
    }
    
    public func configure(with viewModel: SearchResultViewModel) {
        
        self.viewModel = viewModel
    }
}


extension SearchResultsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
}

extension SearchResultsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

extension SearchResultsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentViewModel = collectionViewCellViewModel[indexPath.row]
        if let characterVM = currentViewModel as? CharacterCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: characterVM)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? CharacterEpisodeCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let episodeVM = currentViewModel as? CharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        return cell
    }
}

extension SearchResultsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let currentViewModel = collectionViewCellViewModel[indexPath.row]
        if currentViewModel is CharacterCollectionViewCellViewModel {
            let bounds = UIScreen.main.bounds
            let width = (bounds.width-30)/2
            let height = width*1.5
            return CGSize(width: width, height: height)
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension SearchResultsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
