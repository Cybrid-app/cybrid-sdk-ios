//
//  Polling.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/11/22.
//

import Foundation

open class Polling {

    var timer: DispatchSourceTimer
    var runner: () -> Void
    let queue = DispatchQueue.global(qos: .background)
    let updateInterval = 4

    init(_ runner: @escaping () -> Void) {

        self.runner = runner
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        self.timer.schedule(deadline: .now(), repeating: .seconds(self.updateInterval), leeway: .seconds(0))
        self.timer.setEventHandler { self.runner() }
        timer.resume()
    }

    func stop() {

        timer.cancel()
    }
}
