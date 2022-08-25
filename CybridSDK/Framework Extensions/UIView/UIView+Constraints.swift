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

  func constraintEdges(to item: UIView,
                       insets: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    self.constraint(
      attribute: .top,
      relatedBy: .equal,
      toItem: item,
      attribute: .topMargin,
      multiplier: 1.0,
      constant: insets.top
    )
    self.constraint(
      attribute: .bottom,
      relatedBy: .equal,
      toItem: item,
      attribute: .bottomMargin,
      multiplier: 1.0,
      constant: insets.bottom.isZero ? 0 : -insets.bottom
    )
    self.constraint(
      attribute: .leading,
      relatedBy: .equal,
      toItem: item,
      attribute: .leading,
      multiplier: 1.0,
      constant: insets.left
    )
    self.constraint(
      attribute: .trailing,
      relatedBy: .equal,
      toItem: item,
      attribute: .trailing,
      multiplier: 1.0,
      constant: insets.right.isZero ? 0 : -insets.right
    )
  }

  func removeConstraints() {
    let currentContraints = constraints
    currentContraints.forEach { constraint in
      constraint.isActive = false
      removeConstraint(constraint)
    }
  }

    func setConstraintsSize(size: CGSize) {

        self.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: size.width)
        self.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: size.height)
    }

    func addBelow(toItem: UIView, height: CGFloat, margins: UIEdgeInsets) {

        if toItem.superview != nil {

            toItem.superview?.addSubview(self)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.constraint(attribute: .top,
                            relatedBy: .equal,
                            toItem: toItem,
                            attribute: .bottom,
                            constant: margins.top)
            self.constraint(attribute: .leading,
                            relatedBy: .equal,
                            toItem: toItem.superview,
                            attribute: .leading,
                            constant: margins.left)
            self.constraint(attribute: .trailing,
                            relatedBy: .equal,
                            toItem: toItem.superview,
                            attribute: .trailing,
                            constant: -margins.right)
            self.constraint(attribute: .height,
                            relatedBy: .equal,
                            toItem: nil,
                            attribute: .notAnAttribute,
                            constant: height)
        }
    }
}
