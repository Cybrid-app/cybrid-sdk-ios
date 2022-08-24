//
//  UIFotn+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 24/08/22.
//

import Foundation
import UIKit

extension UIFont {
    
    static func make(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .regular)
    }
}
