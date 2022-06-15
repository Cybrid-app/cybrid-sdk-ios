//
//  AsyncMockOperation.swift
//  CybridSDKTests
//
//  Created by Cybrid on 15/06/22.
//

@testable import CybridSDK
import Foundation

final class AsyncMockOperation: AsyncOperation {
  private var mock: String?
  private var onStart: (() -> Void)?

  func onStart(_ onStart: @escaping () -> Void) {
    self.onStart = onStart
  }

  override func start() {
    super.start()
    onStart?()
  }

  override func main() {
    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let self = self else { return }
      defer { self.state = .finished }
      sleep(1)
      self.mock = "Mock"
    }
  }
}
