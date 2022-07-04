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
}
