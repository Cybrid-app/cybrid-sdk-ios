//
//  UIFont+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 13/09/22.
//

import Foundation
import UIKit

extension UIFont {

    static func make(ofSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: weight)
    }
}
