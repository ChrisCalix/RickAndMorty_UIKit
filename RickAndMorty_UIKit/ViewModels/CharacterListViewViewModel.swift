//
//  CharacterListViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import UIKit

protocol CharacterListViewViewModelDelegate: AnyObject {
    
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with indexPaths: [IndexPath])
    func didSelectCharacter(_ character: Character)
}

final class CharacterListViewViewModel: NSObject {
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    private var apiInfo: GetAllCharactersResponse.Info?
    private var cellViewModels: [CharacterCollectionViewCellViewModel] = []
    private var characters: [Character] = [] {
        didSet {
            for character in self.characters where !self.cellViewModels.contains(where: { $0.characterId == character.id}) {
                let viewModel = CharacterCollectionViewCellViewModel(characterId: character.id, characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
                self.cellViewModels.append(viewModel)
            }
        }
    }
    private var isLoadingMoreCharacters = false
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    /// Fetch initial set of characters(20)
    public func fetchCharacters() {
        
        RMService.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                for char in model.results {
                    print("name: \(char.name), id:\(char.id)")
                }
                self.apiInfo = model.info
                self.characters = model.results
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print("Error \(String(describing: error))")
            }
        }
    }
    
    /// Paginate if aditional characters are needed
    public func fetchAditionalCharacters(from url: URL) {
        guard !isLoadingMoreCharacters else { return }
        
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let self else { return }
            
            defer { self.isLoadingMoreCharacters = false }
            
            switch result {
            case .success(let model):
                for char in model.results {
                    print("name: \(char.name), id:\(char.id)")
                }
                let moreResults = model.results
                let originalCount = self.characters.count
                let newCount = moreResults.count
                let indexPathsToAdd: [IndexPath] = Array(originalCount..<(originalCount+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                self.apiInfo = model.info
                self.characters.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

//  MARK: UICollection Implementations
extension CharacterListViewViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell else {
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

extension CharacterListViewViewModel: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

extension CharacterListViewViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        let height = width*1.5
        return CGSize(width: width, height: height)
    }
}

//MARK: ScrollView
extension CharacterListViewViewModel: UIScrollViewDelegate {
    
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
            fetchAditionalCharacters(from: nextUrl)
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
