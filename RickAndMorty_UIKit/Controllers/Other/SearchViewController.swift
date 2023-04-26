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
        
//        viewModel.executeSearch()
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
        
        print("should presnet option picker \(option.rawValue)")
    }
}
