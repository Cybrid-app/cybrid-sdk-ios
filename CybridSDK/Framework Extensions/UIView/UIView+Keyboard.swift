//
//  UIView+Keyboard.swift
//  CybridSDK
//
//  Created by Cybrid on 19/07/22.
//

import UIKit

extension UIView {
  func makeKeyboardHandler() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    addGestureRecognizer(tap)
  }

  @objc
  func dismissKeyboard() {
    endEditing(true)
  }
}
