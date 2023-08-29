//
//  TextFieldRightIcon.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 22/08/23.
//

import UIKit

class TextFieldRightIcon: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 42.5)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
