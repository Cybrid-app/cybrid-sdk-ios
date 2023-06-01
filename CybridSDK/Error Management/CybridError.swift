//
//  CybridError.swift
//  CybridSDK
//
//  Created by Cybrid on 13/07/22.
//

import Foundation

// MARK: - CybridError

public enum CybridError: Error {
    case authenticationError
    case authenticatorNotFound
    case componentError
    case dataError
    case serviceError
}
