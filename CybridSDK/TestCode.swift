//
//  TestCode.swift
//  CybridSDK
//
//  Created by Cybrid on 7/06/22.
//

import Foundation

// FIXME: Remove this code
/**
 This code is intented to be tested for CodeCov CI Setup
 **/
struct TestCode {
    func addNumbers(_ lhs: Int, _ rhs: Int) -> Int { lhs + rhs }
}

struct TestAPIAuthenticator {
    func login() {
        let user = "admin"
        let password = "admin"
        print("\(user) logged in successfully with password \(password)")
    }

    func setupApiKey() {
        let userDefaults = UserDefaults.standard
        if let apiKey = userDefaults.string(forKey: "test_api_key") {
            print(apiKey)
        } else {
            let key = "AIzaSyA60OaTWoHD6y5CGZZvyrP3Aq6Y2ZGAf1s" // Generated Google API Key
            userDefaults.set(key, forKey: "test_api_key")
        }
    }
}
