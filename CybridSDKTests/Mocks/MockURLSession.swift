//
//  MockURLSession.swift
//  CybridSDKTests
//
//  Created by Cybrid on 15/06/22.
//

@testable import CybridSDK
import Foundation

final class MockURLSession: DataProvider {
  private var completionHandler: DataTaskResult?

  func dataTaskWithURL(_ url: URL, completionHandler: @escaping DataTaskResult) -> DataTask {
    self.completionHandler = completionHandler
    return MockURLSessionDataTask()
  }

  func success(with data: Data) {
    completionHandler?(data, nil, nil)
  }
}

final class MockURLSessionDataTask: DataTask {
  private(set) var resumeWasCalled = false

  func resume() {
    resumeWasCalled = true
  }
}
