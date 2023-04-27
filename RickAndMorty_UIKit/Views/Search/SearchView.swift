//
//  SearchView.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    
    func searchView(_ searchView: SearchView, didSelectOption option: SearchInputViewViewModel.DynamicOption)
    func searchView(_ searchView: SearchView, didSelectLocation location: Location)
}

final class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate?
    private let viewModel: SearchViewViewModel
    private let searchInputView = SearchInputView()
    private let noResultsView = NoSearchResultsView()
    private let resultsView = SearchResultsView()

    init(frame: CGRect, viewModel: SearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView, resultsView)
        addConstraints()
        searchInputView.configure(with: SearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        setupHandlers(using: viewModel)
        resultsView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            // Search input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 60 :  110),
            //Noresult
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            //results
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor, constant: 16),
        ])
    }
    
    private func setupHandlers(using viewModel: SearchViewViewModel) {
        
        viewModel.registerOptionChangeBlock { option, value in
            // tuple: option
            self.searchInputView.update(option: option, value: value)
        }
        
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.presentationResult(showing: true)
            }
        }
        
        viewModel.registerNoResultHandler { [weak self] in
            DispatchQueue.main.async {
                self?.presentationResult(showing: false)
            }
        }
    }
    
    private func presentationResult(showing: Bool) {
        
        self.noResultsView.isHidden = showing
        self.resultsView.isHidden = !showing
    }
    
    public func presentKeyboard() {
        
        searchInputView.presentKeyboard()
    }
}

extension SearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension SearchView: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension SearchView: SearchInputViewDelegate {
    
    func searchInputView(_ input: SearchInputView, didSelectOption option: SearchInputViewViewModel.DynamicOption) {
        
        delegate?.searchView(self, didSelectOption: option)
    }
    
    func searchInputView(_ input: SearchInputView, didChangeSearchtext text: String) {
        
        viewModel.set(query: text)
    }
    
    func searchInputViewDidTapSearchkeyboardButton(_ input: SearchInputView) {
        
        viewModel.executeSearch()
    }
}

extension SearchView: SearchResultsViewDelegate {
    
    func searchResultsView(_ resultView: SearchResultsView, didTapLocationAt index: Int) {
        
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.searchView(self, didSelectLocation: locationModel)
    }
    
}
