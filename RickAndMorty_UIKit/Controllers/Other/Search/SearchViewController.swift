//
//  SearchViewController.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 24/4/23.
//

import UIKit

/// ConfigurableController to search
class SearchViewController: UIViewController {
    
    /// Configuration for search session
    struct Config {
        
        enum `Type` {
            
            case character // name status gender
            case episode // name
            case location // name type
            
            var endpoint: RMEndpoint {
                switch self {
                case .character:
                    return .character
                case .episode:
                    return .episode
                case .location:
                    return .location
                }
            }
            var title: String {
                switch self {
                case .character:
                    return "Search Character"
                case .location:
                    return "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let searchView: SearchView
    private let viewModel: SearchViewViewModel
    
    init(config: Config) {
        viewModel = SearchViewViewModel(config: config)
        searchView = SearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Ussupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExecuteSearch))
        searchView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchView.presentKeyboard()
    }
    
    @objc private func didTapExecuteSearch() {
        
        viewModel.executeSearch()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension SearchViewController: SearchViewDelegate {
    
    func searchView(_ searchView: SearchView, didSelectOption option: SearchInputViewViewModel.DynamicOption) {
        
        let vc = SearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        if #available(iOS 15.0, *) {
            vc.sheetPresentationController?.detents = [.medium()]
            vc.sheetPresentationController?.prefersGrabberVisible = true
        } else {
            vc.modalPresentationStyle = .overCurrentContext
        }
        present(vc, animated: true)
    }
    
    func searchView(_ searchView: SearchView, didSelectLocation location: Location) {
        
        let vc = LocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
