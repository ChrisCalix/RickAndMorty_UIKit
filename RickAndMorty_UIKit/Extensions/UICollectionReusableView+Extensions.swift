//
//  UICollectionReusableView+Extensions.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 23/4/23.
//

import UIKit

extension UICollectionReusableView {
    
    static var identifier: String {
        return String(describing: self)
    }
}
