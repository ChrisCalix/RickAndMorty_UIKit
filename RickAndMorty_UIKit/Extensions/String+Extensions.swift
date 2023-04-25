//
//  String+Extensions.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import Foundation

extension String {
    
    func toDateFormat(using: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = .current
        
        return formatter.date(from: self)
    }
    
    func toShortDateFormatter() -> String {
        
        guard let date = toDateFormat() else {
            return self
        }
        return date.toShortFormatter()
    }
}
