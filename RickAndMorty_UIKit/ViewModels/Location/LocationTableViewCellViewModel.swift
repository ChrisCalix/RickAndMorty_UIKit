//
//  LocationTableViewCellViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import Foundation

struct LocationTableViewCellViewModel {
    
    private let location: Location
    public var id: Int {
        return location.id
    }
    public var name: String {
        return location.name
    }
    public var type: String {
        return "Type: \(location.type)"
    }
    public var dimension: String {
        return location.dimension
    }
    
    init(location: Location) {
        self.location = location
    }
    
}
