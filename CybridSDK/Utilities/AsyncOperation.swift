//
//  AsyncOperation.swift
//  CybridSDK
//
//  Created by Cybrid on 15/06/22.
//

import Foundation

/**
 `AsyncOperation`:
 Operations are Synchronous by default. And their state is a get-only property.
 AsyncOperation lets you run operations asynchronously while giving you the capability to manage the state.
 We need to create a custom AsyncOperation to be able to run them asynchronously and still be able to manage the state.

 Credits to: https://www.raywenderlich.com/books/concurrency-by-tutorials

 This class is intented as a base class. It must not be used directly.
 We are keeping it internal because we don't want to expose it outside our SDK's scope.
 */
class AsyncOperation: Operation {
  static let unimplementedErrorMessage: String = "main() was not implemented."

  var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }

  /// We don't really know wether the base class is in a isReady state. So we need to check that first.
  override var isReady: Bool { return super.isReady && state == .ready }
  override var isExecuting: Bool { return state == .executing }
  override var isFinished: Bool { return state == .finished }
  override var isAsynchronous: Bool { true }

  override func start() {
    main()
    state = .executing
  }

  override func main() {
    assertionFailure(AsyncOperation.unimplementedErrorMessage)
  }
}

extension AsyncOperation {
  /*
   Since Operation State is Internal we need to create a custom State in order to manage it.
   */
  enum State: String {
    case ready
    case executing
    case finished

    /*
     This keypath is intended to translate our Custom State into Operation's Internal State.
     Operation states are:
     - isReady
     - isExecuting
     - isFinished
     */
    var keyPath: String {
      return "is\(rawValue.capitalized)"
    }
  }
}
