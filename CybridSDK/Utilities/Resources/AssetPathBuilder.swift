//
//  AssetPathBuilder.swift
//  CybridSDK
//
//  Created by Cybrid on 4/07/22.
//

import Foundation

extension CybridConfig {
  func getCryptoIconURLString(with code: String) -> String {
    return Cybrid.assetsURL + "pdf/color/" + code.lowercased() + ".pdf"
  }
}
