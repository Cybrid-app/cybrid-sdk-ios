//
//  CybridSession.swift
//  CybridSDK
//
//  Created by Cybrid on 8/07/22.
//

import CybridApiBankSwift
import Foundation

final class CybridSession {

  static var current = CybridSession(authenticator: Cybrid.authenticator, apiManager: CybridApiBankSwiftAPI.self)

  internal var isAuthenticated: Bool {
    return apiManager.hasHeader("Authorization")
  }

  // MARK: ServiceProviders APIs
  internal var listSymbolsService: SymbolsAPI.Type = SymbolsAPI.self

  // MARK: Private properties
  private var authenticator: CybridAuthenticator?
  private var apiManager: CybridAPIManager.Type

  init(authenticator: CybridAuthenticator?, apiManager: CybridAPIManager.Type) {
    self.authenticator = authenticator
    self.apiManager = apiManager
  }

  internal func setupSession(authToken: String) {
    apiManager.setHeader("Authorization", value: "Bearer \(authToken)")
  }

  /// Clears session's Authorization headers.
  internal func clearSession() {
    apiManager.clearHeaders()
  }

  /// Makes sure we have a valid authenticated session.
  internal func authenticate(_ completion: @escaping (Result<Void, Error>) -> Void) {
    /// If it has an Authorization header we return.
    if isAuthenticated {
      completion(.success(()))
      return
    }
    guard let authenticator = authenticator else {
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

  internal func request<T: Any>(_ request: @escaping (_ completion: @escaping (Result<T, ErrorResponse>) -> Void) -> Void,
                                completion: @escaping (Result<T, ErrorResponse>) -> Void) {
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
        completion(.failure(.error(1, nil, nil, CybridError.authenticationError)))
      }
    }
  }
}
