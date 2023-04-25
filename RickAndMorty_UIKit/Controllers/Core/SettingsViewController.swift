//
//  SettingsViewController.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

/// Controller to show various app optins and settings
final class SettingsViewController: UIViewController {
    
    private var settingsSwiftUiController: UIHostingController<SettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        
        let settingsSwiftUiController = UIHostingController(rootView: SettingsView(viewModel: SettingsViewViewModel(cellViewModels: SettingsOption.allCases.compactMap({
            return SettingsCellViewViewModel(type: $0) { [weak self] option in
                self?.handleTap(option: option)
            }
        }))))
        addChild(settingsSwiftUiController)
        settingsSwiftUiController.didMove(toParent: self)
        view.addSubview(settingsSwiftUiController.view)
        settingsSwiftUiController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsSwiftUiController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUiController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUiController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUiController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        self.settingsSwiftUiController = settingsSwiftUiController
    }
    
    private func handleTap(option: SettingsOption) {
        guard Thread.current.isMainThread else {
            return
        }
        if let url = option.targetURL {
            
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            if let windowScene = self.view.window?.windowScene {
                if #available(iOS 14.0, *) {
                    SKStoreReviewController.requestReview(in: windowScene)
                } else {
                    SKStoreReviewController.requestReview()
                }
            }
        }
    }
}
