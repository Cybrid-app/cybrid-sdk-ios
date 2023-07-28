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
  var apiManager = MockAPIManager.self
  var notificationManager = NotificationCenterMock()

    override func tearDownWithError() throws {
        apiManager.clearHeaders()
    }

    func testSessionInitialization() {
        let newSession = createSession()
        XCTAssertFalse(newSession.isAuthenticated)
    }

    func testSession_setupBearer() {
        // Given
        let session = createSession()
        let bearer = "Mock_Bearer"

        // When
        session.setupSession(authToken: bearer)

        // Then
        XCTAssertTrue(session.isAuthenticated)
    }

    func testSession_setupBearer_andClear() {
        // Given
        let session = createSession()
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
        let session = createSession()
        let expectedToken = "Mock_Bearer"
        let expectedBearer = "Bearer Mock_Bearer"
        var didFail = false

        // When
        session.setupSession(authToken: expectedToken)
        session.authenticate { result in
            switch result {
            case .failure:
                didFail = true
            case .success:
                didFail = false
            }
        }

        // Then
        XCTAssertFalse(didFail)
        XCTAssertEqual(MockAPIManager.customHeaders["Authorization"], expectedBearer)
    }

    func testSession_authenticateTwice() {
        // Given
        let session = createSession()
        let initialToken = "Mock_Bearer_One"
        let initialBearer = "Bearer Mock_Bearer_One"
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

    // Then
    XCTAssertFalse(didFail)
    XCTAssertEqual(MockAPIManager.customHeaders["Authorization"], initialBearer)
    }

    func testSession_authenticateWithoutAuthenticator() {
        // Given
        let session = createSession()
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
        let session = createSession()
        var didFail = false
        var errorAssert: Error! = nil

        // When
        session.authenticate { result in
            switch result {
            case .failure(let error):
                didFail = true
                errorAssert = error
            case .success:
                didFail = false
            }
        }

        // Then
        XCTAssertTrue(didFail)
        XCTAssertFalse(session.isAuthenticated)
        XCTAssertEqual(errorAssert.localizedDescription, CybridError.authenticationError.localizedDescription)
    }

    func testSession_authenticatedRequest_successful() {
        // Given
        let session = createSession()
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
        let session = createSession()
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

    func testSession_authenticatedRequestWithParams_failure() {
        // Given
        let session = createSession()
        let expectedResult = "Success"
        var actualResult: String?

        // When
        session.authenticatedRequest(_: { _, completion in
            // Mock response
            completion(Result<String, ErrorResponse>.failure(.error(1, nil, nil, CybridError.serviceError)))
        },
        parameters: "Input",
        completion: { result in
            switch result {
            case .success(let value):
              actualResult = value
            case .failure:
              actualResult = nil
            }
        })

        // Then
        XCTAssertFalse(session.isAuthenticated)
        XCTAssertNotEqual(actualResult, expectedResult)
        XCTAssertNil(actualResult)
    }

    func testSession_unauthenticatedRequest() {
        // Given
        let session = createSession()
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

    func testSession_startScheduler() {
        // Given
        let session = createSession()
        let scheduler = TaskSchedulerMock()
        session.taskSchedulers.insert(scheduler)

        // When
        scheduler.start()

        // Then
        XCTAssertTrue(scheduler.state == .running)
    }

    func testSession_moveToBackground() {
        // Given
        let session = createSession()
        let scheduler = TaskSchedulerMock()
        session.taskSchedulers.insert(scheduler)

        // When
        scheduler.start()
        notificationManager.post(name: CybridSession.appMovedToBackgroundEvent, object: nil, userInfo: nil)

        // Then
        XCTAssertTrue(scheduler.state == .paused)
    }

    func testSession_moveToForeground() {
        // Given
        let session = createSession()
        let scheduler = TaskSchedulerMock()
        session.taskSchedulers.insert(scheduler)

        // When
        scheduler.start()
        notificationManager.post(name: CybridSession.appMovedToBackgroundEvent, object: nil, userInfo: nil)
        notificationManager.post(name: CybridSession.appMovedToForegroundEvent, object: nil, userInfo: nil)

        // Then
        XCTAssertTrue(scheduler.state == .running)
    }
}

extension CybridSessionTests {
    func createSession() -> CybridSession {
        CybridSession(apiManager: apiManager, notificationManager: notificationManager)
    }
}
