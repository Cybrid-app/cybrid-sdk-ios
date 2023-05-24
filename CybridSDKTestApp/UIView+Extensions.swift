//
//  UIView+Extensions.swift
//  CybridSDKTestApp
//
//  Created by Erick Sanchez Perez on 24/05/23.
//

import Foundation
import UIKit

public extension UIView {
    
    @discardableResult
    func constraint(attribute attr1: NSLayoutConstraint.Attribute,
                    relatedBy relation: NSLayoutConstraint.Relation,
                    toItem item: UIView?,
                    attribute attr2: NSLayoutConstraint.Attribute,
                    multiplier: CGFloat = 1.0,
                    constant: CGFloat = 0) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attr1,
            relatedBy: relation,
            toItem: item,
            attribute: attr2,
            multiplier: multiplier,
            constant: constant
        )
        constraint.isActive = true
        return constraint
    }
}
