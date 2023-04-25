//
//  SettingsOption.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import UIKit

enum SettingsOption: CaseIterable {
    
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Term of Services"
        case .privacy:
            return "Privacy"
        case .apiReference:
            return "API References"
        case .viewSeries:
            return "View video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemRed
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemOrange
        case .viewSeries:
            return .systemPurple
        case .viewCode:
            return .systemPink
        }
    }
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    var targetURL: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https:iosacademy.io")
        case .terms:
            return URL(string: "https:iosacademy.io/terms")
        case .privacy:
            return URL(string: "https:iosacademy.io/privacy")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation/#get-a-single-episode")
        case .viewSeries:
            return URL(string: "http://www.youtube.com")
        case .viewCode:
            return URL(string: "https://github.com/ChrisCalix")
        }
    }
}
