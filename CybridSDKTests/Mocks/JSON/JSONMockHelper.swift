//
//  JSONMockHelper.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/07/22.
//

import Foundation

func getJSONData(from fileName: String) -> Data? {
  let bundle = Bundle(for: MockAPIManager.self)
  guard let path = bundle.path(forResource: fileName, ofType: "json") else { return nil }
  return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
}
