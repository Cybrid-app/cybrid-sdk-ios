//
//  UIView+Constraints.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

// MARK: - Constraints

extension UIView {
  @discardableResult
  func constraint(attribute attr1: NSLayoutConstraint.Attribute,
                  relatedBy relation: NSLayoutConstraint.Relation,
                  toItem item: UIView?,
                  attribute attr2: NSLayoutConstraint.Attribute,
                  multiplier: CGFloat = 1.0,
                  constant: CGFloat = 0) -> NSLayoutConstraint {
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
