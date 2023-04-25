//
//  EpisodeListViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 24/4/23.
//

import UIKit

protocol EpisodeListViewViewModelDelegate: AnyObject {
    
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with indexPaths: [IndexPath])
    func didSelectEpisode(_ episode: Episode)
}

/// View Model to handle episode list view loginc
final class EpisodeListViewViewModel: NSObject {
    
    public weak var delegate: EpisodeListViewViewModelDelegate?
    private var apiInfo: GetAllEpisodesResponse.Info?
    private var cellViewModels: [CharacterEpisodeCollectionViewCellViewModel] = []
    private var episodes: [Episode] = [] {
        didSet {
            for episode in self.episodes {
                let viewModel = CharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url), borderColor: borderColors.randomElement() ?? .secondaryLabel)
                if !cellViewModels.contains(viewModel) {
                    self.cellViewModels.append(viewModel)
                }
            }
        }
    }
    private var isLoadingMoreCharacters = false
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemIndigo
    ]
    
    /// Fetch initial set of characters(20)
    public func fetchEpisodes() {
        
        RMService.shared.execute(.listEpisodesRequests, expecting: GetAllEpisodesResponse.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                self.apiInfo = model.info
                self.episodes = model.results
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print("Error \(String(describing: error))")
            }
        }
    }
    
    /// Paginate if aditional characters are needed
    public func fetchAditionalEpisodes(from url: URL) {
        guard !isLoadingMoreCharacters else { return }
        
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request, expecting: GetAllEpisodesResponse.self) { [weak self] result in
            guard let self else { return }
            
            defer { self.isLoadingMoreCharacters = false }
            
            switch result {
            case .success(let model):
                let moreResults = model.results
                let originalCount = self.episodes.count
                let newCount = moreResults.count
                let indexPathsToAdd: [IndexPath] = Array(originalCount..<(originalCount+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                self.apiInfo = model.info
                self.episodes.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

//  MARK: UICollection Implementations
extension EpisodeListViewViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? CharacterEpisodeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
                                                                           for: indexPath) as? FooterLoadingCollectionReusableView else {
            return UICollectionReusableView()
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else { return .zero }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension EpisodeListViewViewModel: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}

extension EpisodeListViewViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = collectionView.bounds
        let width = (bounds.width-20)
        return CGSize(width: width, height: 130)
    }
}

//MARK: ScrollView
extension EpisodeListViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let nextUrl = URL(string: nextUrlString) else { return }
        
        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        //TODO: check first state if offset is less than 0
        if offset > 0 && offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            fetchAditionalEpisodes(from: nextUrl)
        }
        
//        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] time in
//            guard let self else { return }
//
//            let offset = scrollView.contentOffset.y
//            let totalContentHeight = scrollView.contentSize.height
//            let totalScrollViewFixedHeight = scrollView.frame.size.height
//
//            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
//                print("We should start fetching more")
//                self.fetchAditionalCharacters(from: nextUrl)
//            }
//            time.invalidate()
//        }
    }
}
