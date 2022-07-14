//
//  MockCybridAuthenticator.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

import CybridSDK

class MockAuthenticator: CybridAuthenticator {
  private var authenticationCompletion: ((Result<CybridBearer, Error>) -> Void)?

  func makeCybridAuthToken(completion: @escaping (Result<CybridBearer, Error>) -> Void) {
    self.authenticationCompletion = completion
  }

  func authenticationSuccess(with token: String = "MOCK-BEARER") {
    authenticationCompletion?(.success(token))
  }

  func authenticationFailure() {
    authenticationCompletion?(.failure(CybridError.authenticationError))
  }
}
