//
//  CybridSessionTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class CybridSessionTests: XCTestCase {
  var authenticator = MockAuthenticator()
  var apiManager = MockAPIManager.self
  var notificationManager = NotificationCenterMock()

  override func tearDownWithError() throws {
    apiManager.clearHeaders()
  }

  func testSessionInitialization() {
    let newSession = createSession(authenticator: authenticator)
    XCTAssertFalse(newSession.isAuthenticated)
  }

  func testSession_setupBearer() {
    // Given
    let session = createSession(authenticator: authenticator)
    let bearer = "Mock_Bearer"

    // When
    session.setupSession(authToken: bearer)

    // Then
    XCTAssertTrue(session.isAuthenticated)
  }

  func testSession_setupBearer_andClear() {
    // Given
    let session = createSession(authenticator: authenticator)
    let bearer = "Mock_Bearer"

    // When
    session.setupSession(authToken: bearer)

    // Then
    XCTAssertTrue(session.isAuthenticated)

    // When
    session.clearSession()
    // Then
    XCTAssertFalse(session.isAuthenticated)
  }

  func testSession_authenticateFirstTime() {
    // Given
    let session = createSession(authenticator: authenticator)
    let expectedToken = "Mock_Bearer"
    let expectedBearer = "Bearer Mock_Bearer"
    var didFail = false

    // When
    session.authenticate { result in
      switch result {
      case .failure:
        didFail = true
      case .success:
        didFail = false
      }
    }
    authenticator.authenticationSuccess(with: expectedToken)

    // Then
    XCTAssertFalse(didFail)
    XCTAssertEqual(MockAPIManager.customHeaders["Authorization"], expectedBearer)
  }

  func testSession_authenticateTwice() {
    // Given
    let session = createSession(authenticator: authenticator)
    let initialToken = "Mock_Bearer_One"
    let initialBearer = "Bearer Mock_Bearer_One"
    let secondToken = "Mock_Bearer"
    var didFail = false

    // When
    session.setupSession(authToken: initialToken)
    XCTAssertTrue(session.isAuthenticated)
    session.authenticate { result in
      switch result {
      case .failure:
        didFail = true
      case .success:
        didFail = false
      }
    }
    authenticator.authenticationSuccess(with: secondToken)

    // Then
    XCTAssertFalse(didFail)
    XCTAssertEqual(MockAPIManager.customHeaders["Authorization"], initialBearer)
  }

  func testSession_authenticateWithoutAuthenticator() {
    // Given
    let session = createSession(authenticator: nil)
    var didFail = false

    // When
    session.authenticate { result in
      switch result {
      case .failure:
        didFail = true
      case .success:
        didFail = false
      }
    }

    // Then
    XCTAssertTrue(didFail)
    XCTAssertFalse(session.isAuthenticated)
  }

  func testSession_authenticateFailure() {
    // Given
    let session = createSession(authenticator: authenticator)
    var didFail = false

    // When
    session.authenticate { result in
      switch result {
      case .failure:
        didFail = true
      case .success:
        didFail = false
      }
    }
    authenticator.authenticationFailure()

    // Then
    XCTAssertTrue(didFail)
    XCTAssertFalse(session.isAuthenticated)
  }

  func testSession_authenticatedRequest_successful() {
    // Given
    let session = createSession(authenticator: authenticator)
    let expectedResult = "Success"
    var actualResult: String?

    // When
    session.setupSession(authToken: "Mock_Bearer")
    session.authenticatedRequest { completion in
      // Mock response
      completion(.success("Success"))
    } completion: { result in
      switch result {
      case .success(let value):
        actualResult = value
      case .failure:
        actualResult = nil
      }
    }

    // Then
    XCTAssertTrue(session.isAuthenticated)
    XCTAssertEqual(actualResult, expectedResult)
  }

  func testSession_authenticatedRequest_failure() {
    // Given
    let session = createSession(authenticator: authenticator)
    let expectedResult = "Success"
    var actualResult: String?

    // When
    session.setupSession(authToken: "Mock_Bearer")
    session.authenticatedRequest { completion in
      // Mock response
      completion(Result<String, ErrorResponse>.failure(.error(1, nil, nil, CybridError.serviceError)))
    } completion: { result in
      switch result {
      case .success(let value):
        actualResult = value
      case .failure:
        actualResult = nil
      }
    }

    // Then
    XCTAssertTrue(session.isAuthenticated)
    XCTAssertNotEqual(actualResult, expectedResult)
    XCTAssertNil(actualResult)
  }

  func testSession_unauthenticatedRequest() {
    // Given
    let session = createSession(authenticator: nil)
    let expectedResult = "Success"
    var actualResult: String?

    // When
    session.authenticatedRequest { completion in
      // Mock response
      completion(.success("Success"))
    } completion: { result in
      switch result {
      case .success(let value):
        actualResult = value
      case .failure:
        actualResult = nil
      }
    }

    // Then
    XCTAssertFalse(session.isAuthenticated)
    XCTAssertNotEqual(actualResult, expectedResult)
    XCTAssertNil(actualResult)
  }
}

extension CybridSessionTests {
  func createSession(authenticator: CybridAuthenticator?) -> CybridSession {
    CybridSession(authenticator: authenticator, apiManager: apiManager, notificationManager: notificationManager)
  }
}
