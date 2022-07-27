//
//  CybridAuthenticator.swift
//  CybridSDK
//
//  Created by Cybrid on 13/07/22.
//

import Foundation

public typealias CybridBearer = String

public protocol CybridAuthenticator {
  func makeCybridAuthToken(completion: @escaping (Result<CybridBearer, Error>) -> Void)
}
