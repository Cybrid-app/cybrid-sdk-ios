//
//  CYBButton.swift
//  CybridSDK
//
//  Created by Cybrid on 26/07/22.
//

import Foundation
import UIKit

final class CYBButton: UIButton {
  override var intrinsicContentSize: CGSize {
    let baseSize = super.intrinsicContentSize
    return CGSize(width: baseSize.width + Constants.horizontalPadding * 2,
                  height: baseSize.height)
  }
}

// MARK: - Constants

extension CYBButton {
  enum Constants {
    static let horizontalPadding: CGFloat = 20
  }
}
