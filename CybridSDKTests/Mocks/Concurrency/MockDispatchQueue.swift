//
//  MockDispatchQueue.swift
//  CybridSDKTests
//
//  Created by Cybrid on 16/06/22.
//

@testable import CybridSDK
import Foundation

struct MockDispatchQueue: DispatchQueueType {
  func async(execute work: @escaping () -> Void) {
    work()
  }
}
