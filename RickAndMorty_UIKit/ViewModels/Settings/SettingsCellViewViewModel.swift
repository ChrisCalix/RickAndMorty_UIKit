//
//  SettingsCellViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import UIKit

struct SettingsCellViewViewModel: Identifiable {
    
    let id : UUID
    public var image: UIImage?{
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
    public let onTapHandler: (SettingsOption) -> Void
    public let type: SettingsOption
    
    init(type: SettingsOption, onTapHandler: @escaping (SettingsOption) -> Void) {
        
        self.type = type
        self.id = UUID()
        self.onTapHandler = onTapHandler
    }
}
