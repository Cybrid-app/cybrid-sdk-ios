//
//  UIView+Constraints.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

// MARK: - Constraints

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

    func removeConstraint(attribute: NSLayoutConstraint.Attribute) {

        let currentContraints = constraints
        currentContraints.forEach { constraint in
            if constraint.firstAttribute == attribute {
                constraint.isActive = false
                removeConstraint(constraint)
            }
        }
    }

    func setConstraintsSize(size: CGSize) {

        self.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: size.width)
        self.constraint(attribute: .height,
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

    func addBelowToBottom(topItem: UIView, bottomItem: UIView, margins: UIEdgeInsets) {

        if topItem.superview != nil {

            topItem.superview?.addSubview(self)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.constraint(attribute: .top,
                            relatedBy: .equal,
                            toItem: topItem,
                            attribute: .bottom,
                            constant: margins.top)
            self.constraint(attribute: .leading,
                            relatedBy: .equal,
                            toItem: topItem.superview,
                            attribute: .leading,
                            constant: margins.left)
            self.constraint(attribute: .trailing,
                            relatedBy: .equal,
                            toItem: topItem.superview,
                            attribute: .trailing,
                            constant: -margins.right)
            self.constraint(attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomItem,
                            attribute: .bottom,
                            constant: -margins.bottom)
        }
    }

    func addInTheMiddle(topItem: UIView, bottomItem: UIView, margins: UIEdgeInsets) {

        if topItem.superview != nil {

            topItem.superview?.addSubview(self)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.constraint(attribute: .top,
                            relatedBy: .equal,
                            toItem: topItem,
                            attribute: .bottom,
                            constant: margins.top)
            self.constraint(attribute: .leading,
                            relatedBy: .equal,
                            toItem: topItem.superview,
                            attribute: .leading,
                            constant: margins.left)
            self.constraint(attribute: .trailing,
                            relatedBy: .equal,
                            toItem: topItem.superview,
                            attribute: .trailing,
                            constant: -margins.right)
            self.constraint(attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomItem,
                            attribute: .top,
                            constant: -margins.bottom)
        }
    }

    func asLast(parent: UIView, height: CGFloat, margins: UIEdgeInsets) {

        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .leading,
                        constant: margins.left)
        self.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .trailing,
                        constant: -margins.right)
        self.constraint(attribute: .bottom,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .bottom,
                        constant: -margins.bottom)
        self.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: height)
    }

    func asFirstIn(_ parent: UIView, height: CGFloat, margins: UIEdgeInsets) {

        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .topMargin,
                        constant: margins.top)
        self.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .leading,
                        constant: margins.left)
        self.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .trailing,
                        constant: -margins.right)
        self.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: height)
    }

    func asFirstInCenter(_ parent: UIView, size: CGSize, margins: UIEdgeInsets) {

        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .topMargin,
                        constant: margins.top)
        self.constraint(attribute: .centerX,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .centerX)
        self.setConstraintsSize(size: size)
    }

    func asFirstWithImage(_ parent: UIView, icon: UIImageView, height: CGFloat, margins: UIEdgeInsets) {

        parent.addSubview(icon)
        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        icon.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .topMargin,
                        constant: margins.top)
        icon.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .leading,
                        constant: margins.left)
        icon.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: height)
        icon.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: height)

        self.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .topMargin,
                        constant: margins.top)
        self.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: icon,
                        attribute: .trailing,
                        constant: 10)
        self.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .trailing,
                        constant: -margins.right)
        self.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: height)
    }

    func addThreeInLine(toItem: UIView,
                        width: CGFloat,
                        height: CGFloat,
                        margins: UIEdgeInsets,
                        second: UIView,
                        secondHeight: CGFloat,
                        secondMargins: UIEdgeInsets,
                        third: UIView,
                        thirdWidth: CGFloat,
                        thirdHeight: CGFloat,
                        thirdMargins: UIEdgeInsets) {

        if toItem.superview != nil {

            toItem.superview?.addSubview(self)
            toItem.superview?.addSubview(second)
            toItem.superview?.addSubview(third)

            // -- First
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
            self.constraint(attribute: .width,
                            relatedBy: .equal,
                            toItem: nil,
                            attribute: .notAnAttribute,
                            constant: width)
            self.constraint(attribute: .height,
                            relatedBy: .equal,
                            toItem: nil,
                            attribute: .notAnAttribute,
                            constant: height)

            // -- Third
            third.translatesAutoresizingMaskIntoConstraints = false
            third.constraint(attribute: .top,
                            relatedBy: .equal,
                            toItem: toItem,
                            attribute: .bottom,
                            constant: thirdMargins.top)
            third.constraint(attribute: .trailing,
                            relatedBy: .equal,
                            toItem: toItem.superview,
                            attribute: .trailing,
                            constant: -thirdMargins.right)
            third.constraint(attribute: .width,
                            relatedBy: .equal,
                            toItem: nil,
                            attribute: .notAnAttribute,
                            constant: thirdWidth)
            third.constraint(attribute: .height,
                            relatedBy: .equal,
                            toItem: nil,
                            attribute: .notAnAttribute,
                            constant: thirdHeight)

            // -- Second
            second.translatesAutoresizingMaskIntoConstraints = false
            second.constraint(attribute: .top,
                            relatedBy: .equal,
                            toItem: toItem,
                            attribute: .bottom,
                            constant: secondMargins.top)
            second.constraint(attribute: .leading,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .trailing,
                            constant: secondMargins.left)
            second.constraint(attribute: .trailing,
                            relatedBy: .equal,
                            toItem: third,
                            attribute: .leading,
                              constant: -secondMargins.right)
            second.constraint(attribute: .height,
                            relatedBy: .equal,
                            toItem: nil,
                            attribute: .notAnAttribute,
                            constant: secondHeight)
        }
    }

    // -- Super Magic cosntraints

    func constraintSafeTop(_ view: UIView, margin: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .topMargin,
                        constant: margin)
    }

    func constraintTop(_ view: UIView, margin: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .top,
                        constant: margin)
    }

    func constraintLeft(_ view: UIView, margin: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .leading,
                        constant: margin)
    }

    func constraintRight(_ view: UIView, margin: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .trailing,
                        constant: -margin)
    }

    func constraintBottom(_ view: UIView, margin: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .bottom,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .bottom,
                        constant: -margin)
    }

    func constraintSafeBottom(_ view: UIView, margin: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .bottom,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .bottomMargin,
                        constant: -margin)
    }

    // swiftlint:disable:next identifier_name
    func below(_ to: UIView, top: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: to,
                        attribute: .bottom,
                        constant: top)
    }

    // swiftlint:disable:next identifier_name
    func above(_ to: UIView, bottom: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .bottom,
                        relatedBy: .equal,
                        toItem: to,
                        attribute: .top,
                        constant: -bottom)
    }

    // swiftlint:disable:next identifier_name
    func leftAside(_ to: UIView, margin: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: to,
                        attribute: .trailing,
                        constant: margin)
    }

    // swiftlint:disable:next identifier_name
    func rightAside(_ to: UIView, margin: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: to,
                        attribute: .leading,
                        constant: -margin)
    }

    func centerHorizontal(parent: UIView) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .centerX,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .centerX)
    }

    func centerVertical(parent: UIView) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .centerY,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .centerY)
    }

    @discardableResult
    func constraintHeight(_ value: CGFloat) -> NSLayoutConstraint {

        self.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = self.constraint(attribute: .height,
                                               relatedBy: .equal,
                                               toItem: nil,
                                               attribute: .notAnAttribute,
                                               constant: value)
        return heightConstraint
    }

    func constraintWidth(_ value: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: value)
    }
}
