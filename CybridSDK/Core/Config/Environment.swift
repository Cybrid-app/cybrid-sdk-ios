//
//  Environment.swift
//  CybridSDK
//
//  Created by Cybrid on 11/07/22.
//

import Foundation

public enum CybridEnvironment {

    case staging
    case sandbox
    case production

    var basePath: String {

        switch self {
        case .staging:
            return "https://bank.staging.cybrid.app"
        case .sandbox:
            return "https://bank.sandbox.cybrid.app"
        case .production:
            return "https://bank.production.cybrid.app"
        }
    }
}
