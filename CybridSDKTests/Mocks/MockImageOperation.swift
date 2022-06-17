//
//  MockImageOperation.swift
//  CybridSDKTests
//
//  Created by Cybrid on 16/06/22.
//

@testable import CybridSDK
import Foundation
import UIKit

class MockImageOperation: AsyncOperation, URLImageOperation {
  var image: UIImage?
  private var shouldWait = false

  init(image: UIImage?) {
    self.image = image
  }

  override func main() {
    if !shouldWait {
      completionBlock?()
    }
  }

  func wait() {
    shouldWait = true
  }

  func resume() {
    shouldWait = false
  }
}

struct MockOperationQueue: OperationQueueType {
  func addOperation(_ operation: Operation) {
    operation.start()
  }
}
