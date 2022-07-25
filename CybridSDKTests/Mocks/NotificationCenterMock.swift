//
//  NotificationCenterMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 25/07/22.
//

@testable import CybridSDK
import Foundation

final class NotificationCenterMock: NotificationManager {
  var observers: [AnyObject] = []

  func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?) {
    observers.append(observer as AnyObject)
  }

  func removeObserver(_ observer: Any) {
    observers.removeAll { element in
      return element === (observer as AnyObject)
    }
  }
}
