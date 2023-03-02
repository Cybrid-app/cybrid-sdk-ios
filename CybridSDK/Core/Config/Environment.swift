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
        return String(format: CybridConfig.baseUrl, "\(self)")
    }
}
