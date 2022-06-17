//
//  ConcurrencyInterfaces.swift
//  CybridSDK
//
//  Created by Cybrid on 16/06/22.
//

import Foundation

protocol OperationQueueType {
  func addOperation(_ operation: Operation)
}

extension OperationQueue: OperationQueueType {}

protocol DispatchQueueType {
  func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueType {
  func async(execute work: @escaping () -> Void) {
    async(group: nil, qos: .unspecified, flags: [], execute: work)
  }
}
