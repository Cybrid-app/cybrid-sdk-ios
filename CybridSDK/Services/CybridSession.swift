//
//  CybridSession.swift
//  CybridSDK
//
//  Created by Cybrid on 8/07/22.
//

import CybridApiBankSwift
import Foundation

protocol AuthenticatedServiceProvider: AnyObject {
  var authenticator: CybridAuthenticator? { get }
  var apiManager: CybridAPIManager.Type { get }
}

extension AuthenticatedServiceProvider {
  var isAuthenticated: Bool {
    return apiManager.hasHeader("Authorization")
  }

  func setupSession(authToken: String) {
    apiManager.setHeader("Authorization", value: "Bearer \(authToken)")
  }

  /// Clears session's Authorization headers.
  func clearSession() {
    apiManager.clearHeaders()
  }

  /// Makes sure we have a valid authenticated session.
  func authenticate(_ completion: @escaping (Result<Void, Error>) -> Void) {
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

  func authenticatedRequest<T: Any>(_ request: @escaping (_ completion: @escaping (Result<T, ErrorResponse>) -> Void) -> Void,
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

final class CybridSession: AuthenticatedServiceProvider {

  static var current = CybridSession(authenticator: Cybrid.authenticator, apiManager: CybridApiBankSwiftAPI.self)

  // MARK: ServiceProviders APIs
  internal var pricesRepository: PricesRepository.Type
  internal var assetsRepository: AssetsRepository.Type

  // MARK: Private properties
  private(set) var authenticator: CybridAuthenticator?
  private(set) var apiManager: CybridAPIManager.Type

  init(authenticator: CybridAuthenticator?, apiManager: CybridAPIManager.Type) {
    self.authenticator = authenticator
    self.apiManager = apiManager
    self.pricesRepository = PricesAPI.self
    self.assetsRepository = AssetsAPI.self
  }

}
