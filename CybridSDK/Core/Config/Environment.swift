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

    public var baseBankPath: String {
        return String(format: CybridConfig.baseBankApiUrl, "\(self)")
    }

    public var baseIdpPath: String {
        return String(format: CybridConfig.baseIdpApiUrl, "\(self)")
    }
}
