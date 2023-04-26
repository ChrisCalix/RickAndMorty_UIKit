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
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Ussupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.type.title
        view.backgroundColor = .systemBackground
    }
    
}
