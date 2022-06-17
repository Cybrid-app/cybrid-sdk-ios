//
//  MockImageOperation.swift
//  CybridSDKTests
//
//  Created by Cybrid on 16/06/22.
//

@testable import CybridSDK
import Foundation
import UIKit

class MockImageOperation: Operation, URLImageOperation {
  var image: UIImage?

  init(image: UIImage?) {
    self.image = image
  }

  override func start() {
    main()
  }

  override func main() {
    completionBlock?()
  }
}

struct MockOperationQueue: OperationQueueType {
  func addOperation(_ operation: Operation) {
    operation.start()
  }
}
