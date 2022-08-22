//
//  Util.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 22/08/22.
//

import Foundation

func stringValue(forKey key: String, in jsonData: Data, atIndex index: Int = 0) -> String? {
  guard let jsonString = String(data: jsonData, encoding: .utf8) else { return nil }
  let recurrentCharacters = CharacterSet(charactersIn: "\n ")
  let arrayContent = jsonString.trimmingCharacters(in: CharacterSet(charactersIn: "\n []{"))
  let dictionaries = arrayContent.split(separator: "}").map {
    $0.trimmingCharacters(in: recurrentCharacters)
  }
  guard dictionaries.count > index else { return nil }
  let selectedDict = dictionaries[index]
  let keypairs = selectedDict.split(separator: ",").map {
    $0.trimmingCharacters(in: recurrentCharacters)
  }
  guard let selectedKeyPair = keypairs.first(where: { substring in
    substring.contains(key)
  }) else { return nil }
  let keyValueSplit = selectedKeyPair.split(separator: ":")
  guard keyValueSplit.count == 2, let value = keyValueSplit.last else { return nil }
  return String(describing: value).trimmingCharacters(in: recurrentCharacters)
}
