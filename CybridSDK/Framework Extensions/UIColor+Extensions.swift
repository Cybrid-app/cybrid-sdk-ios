//
//  UIColor+Extensions.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

extension UIColor {

    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor,
        overrideUserInterfaceStyle: UIUserInterfaceStyle? = nil
    ) {
        self.init { traitCollection in
            let userInterfaceStyle = overrideUserInterfaceStyle ?? traitCollection.userInterfaceStyle
            switch userInterfaceStyle {
            case .light:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            default:
                return lightModeColor()
            }
        }
    }

    public convenience init(hex: String, alpha: CGFloat = 1.0) {

        let chars = Array(hex.dropFirst())
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                  alpha: alpha)
    }
}
