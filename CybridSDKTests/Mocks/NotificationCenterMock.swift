//
//  NotificationCenterMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 25/07/22.
//

@testable import CybridSDK
import Foundation

final class NotificationCenterMock: NotificationManager {

  var observers: [MockObserver] = []

  func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?) {
    observers.append(
      MockObserver(observer: observer as AnyObject,
                   selector: selector,
                   notificationName: name)
    )
  }

  func removeObserver(_ observer: Any) {
    observers.removeAll { element in
      return element.observer === (observer as AnyObject)
    }
  }

  func post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable: Any]?) {
    observers.forEach { observer in
      if observer.notificationName == name {
        observer.observer.perform(observer.selector)
      }
    }
  }
}

struct MockObserver {
  let observer: AnyObject
  let selector: Selector
  let notificationName: NSNotification.Name?
}
