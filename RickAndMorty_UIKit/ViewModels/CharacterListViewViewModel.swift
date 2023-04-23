//
//  CharacterListViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import UIKit

protocol CharacterListViewViewModelDelegate: AnyObject {
    
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: Character)
}

final class CharacterListViewViewModel: NSObject {
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    private var cellViewModels: [CharacterCollectionViewCellViewModel] = []
    private var apiInfo: GetAllCharactersResponse.Info?
    private var characters: [Character] = [] {
        didSet {
            for character in characters {
                let viewModel = CharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
                cellViewModels.append(viewModel)
            }
        }
    }
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    /// Fetch initial set of characters(20)
    public func fetchCharacters() {
        
        RMService.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                let results = model.results
                self.apiInfo = model.info
                self.characters = results
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print("Error \(String(describing: error))")
            }
        }
    }
    
    /// Paginate if aditional characters are needed
    public func fetchAditionalCharacters() {
        
        
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
        guard kind == UICollectionView.elementKindSectionFooter else { return UICollectionReusableView() }
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
                                                                     for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
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
        guard shouldShowLoadMoreIndicator else { return }
    }
}
