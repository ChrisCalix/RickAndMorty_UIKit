//
//  EpisodeDetailViewController.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 24/4/23.
//

import UIKit

/// VC to show details about single episode
final class EpisodeDetailViewController: UIViewController {
    
    private let url: URL?
    
    //MARK: Init
    init(url: URL?) {
        self.url = url
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
