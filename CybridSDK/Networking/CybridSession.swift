//
//  CybridSession.swift
//  CybridSDK
//
//  Created by Cybrid on 8/07/22.
//

import CybridApiBankSwift
import Foundation

class CybridSession {

  static var current = CybridSession()

  private var hasSession: Bool {
    return CybridApiBankSwiftAPI.customHeaders["Authorization"] != nil
  }

  private func setupSession(authToken: String) {
    CybridApiBankSwiftAPI.customHeaders = [
      "Authorization": "Bearer \(authToken)"
    ]
  }

  /// Clears session's Authorization headers.
  private func clearSession() {
    CybridApiBankSwiftAPI.customHeaders = [:]
  }

  /// Makes sure we have a valid authenticated session.
  private func authenticate(_ completion: @escaping (Result<Void, Error>) -> Void) {
    /// If it has an Authorization header we return.
    if hasSession {
      completion(.success(()))
      return
    }
    guard let authenticator = Cybrid.authenticator else {
      clearSession()
      completion(.failure(CybridError.authenticatorNotFound))
      return
    }
    /// Otherwise, we retrieve a new token with authenticator.
    authenticator.makeCybridAuthToken(completion: { [weak self] result in
      switch result {
      case .success(let bearer):
        self?.setupSession(authToken: bearer)
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }

  func request<T: Any>(_ request: @escaping (_ completion: @escaping (Result<T, ErrorResponse>) -> Void) -> Void,
                       completion: @escaping (Result<T, Error>) -> Void) {
    authenticate { authResult in
      switch authResult {
      case .success:
        request { requestResult in
          switch requestResult {
          case .success(let data):
            completion(.success(data))
          case .failure(let error):
            completion(.failure(error))
          }
        }
      case .failure:
        completion(.failure(CybridError.authenticationError))
      }
    }
  }
}
