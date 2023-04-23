//
//  CharacterListViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import UIKit

final class CharacterListViewViewModel: NSObject {
    
    func fetchCharacters() {
        
        RMService.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Success \(String(describing: model))")
            case .failure(let error):
                print("Error \(String(describing: error))")
            }
        }
    }
}

extension CharacterListViewViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemGreen
        return cell
    }    
}

extension CharacterListViewViewModel: UICollectionViewDelegate {
    
}

extension CharacterListViewViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        let height = width*1.5
        return CGSize(width: width, height: height)
    }
}
