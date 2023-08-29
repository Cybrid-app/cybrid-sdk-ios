//
//  UIView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/07/23.
//

import UIKit

extension UIView {

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }

    func removeChilds() {

        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
