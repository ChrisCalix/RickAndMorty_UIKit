//
//  LocationDetailViewController.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    private let viewModel: LocationDetailViewViewModel
    private let detailView = LocationDetailView()
    
    init(location: Location) {
        self.viewModel = .init(endpoint: URL(string: location.url))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Location"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        viewModel.delegate = self
        detailView.delegate = self
        viewModel.fetchLocationsData()
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

extension LocationDetailViewController: LocationDetailViewViewModelDelegate {

    func didFetchLocationDetails() {

        detailView.configure(with: viewModel)
    }
}

extension LocationDetailViewController: LocationDetailViewDelegate {
    
    func locationDetailView(_ detailView: LocationDetailView, didSelect character: Character) {
    
        let vc = CharacterDetailViewController(viewModel: .init(character: character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
