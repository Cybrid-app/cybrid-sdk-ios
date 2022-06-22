//
//  UIColor+Extensions.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

protocol InterfaceStyleProvider {
  var userInterfaceStyle: UIUserInterfaceStyle { get }
}

extension UITraitCollection: InterfaceStyleProvider {}

extension UIColor {
  convenience init(
    light lightModeColor: @escaping @autoclosure () -> UIColor,
    dark darkModeColor: @escaping @autoclosure () -> UIColor,
    interfaceStyleProvider: InterfaceStyleProvider? = nil
  ) {
    self.init { traitCollection in
      let uiStyleProvider = interfaceStyleProvider ?? traitCollection
      switch uiStyleProvider.userInterfaceStyle {
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
