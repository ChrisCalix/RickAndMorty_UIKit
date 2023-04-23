//
//  CharacterDetailViewController.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import UIKit

/// Controller to show info about single character
class CharacterDetailViewController: UIViewController {
    
    private let viewModel: CharacterDetailViewViewModel!
    
    init(viewModel: CharacterDetailViewViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
}
