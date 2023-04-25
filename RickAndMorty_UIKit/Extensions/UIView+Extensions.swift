//
//  UIView+Extensions.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 22/4/23.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        
        views.forEach { view in
            addSubview(view)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
