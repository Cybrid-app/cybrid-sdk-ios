//
//  CYBButton.swift
//  CybridSDK
//
//  Created by Cybrid on 26/07/22.
//

import Foundation
import UIKit

class CYBButton: UIButton {
  private let horizontalPadding: CGFloat = 20
  override var intrinsicContentSize: CGSize {
    let baseSize = super.intrinsicContentSize
    return CGSize(width: baseSize.width + horizontalPadding * 2, height: baseSize.height)
  }
}
