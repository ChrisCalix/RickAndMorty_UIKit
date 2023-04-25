//
//  EpisodeDetailViewController.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 24/4/23.
//

import UIKit

/// VC to show details about single episode
final class EpisodeDetailViewController: UIViewController {
    
    private let viewModel: EpisodeDetailViewViewModel
    private let detailView = EpisodeDetailView()
    
    //MARK: Init
    init(url: URL?) {
        self.viewModel = .init(endpoint: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Filecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episode"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapShare() {
        
    }
}

extension EpisodeDetailViewController: EpisodeDetailViewViewModelDelegate {
    
    func didFetchEpisodeDetails() {
        
        detailView.configure(with: viewModel)
    }
}
