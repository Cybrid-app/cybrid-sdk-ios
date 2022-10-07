//
//  AuthenticatedServiceProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 24/07/22.
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
    authenticator.getBearer(completion: { [weak self] result in
      switch result {
      case .success(let bearer):
        self?.setupSession(authToken: bearer)
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }

  func authenticatedRequest<ResponseType: Any>(
    _ request: @escaping (_ completion: @escaping (Result<ResponseType, ErrorResponse>) -> Void) -> Void,
    completion: @escaping (Result<ResponseType, ErrorResponse>) -> Void
  ) {
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

  func authenticatedRequest<Parameters: Any, ResponseType: Any>(
    _ request: @escaping (_ params: Parameters, _ completion: @escaping (Result<ResponseType, ErrorResponse>) -> Void) -> Void,
    parameters: Parameters,
    completion: @escaping (Result<ResponseType, ErrorResponse>) -> Void
  ) {
    authenticate { authResult in
      switch authResult {
      case .success:
        request(parameters) { requestResult in
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
