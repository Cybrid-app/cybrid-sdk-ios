//
//  String+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 15/09/22.
//

import Foundation

extension String {

    func currencyFormat() -> String {

        let separator = ","
        var result: String = ""
        var iterator = 1

        for character in self.stringValue.reversed() {
            if iterator < 4 {
                result = String(character) + result
                iterator += 1
            } else {
                result = String(character) + separator + result
                iterator = 2
            }
        }
        return result
        
        // CNN
        // NBC
        // Routers
    }

    func removeTrailingZeros() -> String {

        var result = ""
        for character in self.stringValue.reversed() {
            if character != "0" {
                result = String(character) + result
            } else {
                return result
            }
        }
        return result
    }
}
