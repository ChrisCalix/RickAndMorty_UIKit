//
//  Date+Extensions.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import Foundation

extension Date {
    
    func toShortFormatter() -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        
        return formatter.string(from: self)
    }
}
