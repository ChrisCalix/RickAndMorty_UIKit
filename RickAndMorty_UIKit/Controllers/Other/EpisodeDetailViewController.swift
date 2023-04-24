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
        view.backgroundColor = .systemGreen
    }
    
}
