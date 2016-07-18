//
//  Fixtures.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import PainlessInjection
import XCTest

protocol WeatherServiceProtocol {
    func todayTemperature() -> Double
}

class WeatherServce: WeatherServiceProtocol {
    
    var temperature: Double
    init(temperature: Double = 36.6) {
        self.temperature = temperature
    }
    
    func todayTemperature() -> Double {
        return temperature
    }
}

class Weatherman {
    private let _weatherService: WeatherServiceProtocol
    init(weatherService: WeatherServiceProtocol) {
        _weatherService = weatherService
    }
    
    func say() -> String {
        return "Today`s temperature is \(_weatherService.todayTemperature())."
    }
}

class TestFatalErrorNotifier: FatalErrorNotifierProtocol {
    private var lastMessage: String!
    
    func notify(message: String) {
        lastMessage = message
    }
    
    func assertLastMessage(message: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(lastMessage!, message, file: file, line: line)
    }
}


class EmptyTestModule: Module {
    override func load() {
    }
}

protocol ServiceProtocol {
    func send()
}

struct  Service: ServiceProtocol {
    static var createdInstances: Int = 0
    var id: Int
    init() {
        Service.createdInstances += 1
        id = Service.createdInstances
    }
    
    func send() {
        
    }
}

class DependencyDecorator: Dependency {
    var wasCalled = false
    var dependency: Dependency
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    var type: Any.Type {
        return dependency.type
    }
    
    func create(args: [Any]) -> Any {
        wasCalled = true
        return dependency.create(args)
    }
}

class FakeTimer: TimerProtocol {
    var delegate: TimerDelelgate?
    
    func timeout() {
        delegate?.onTick()
    }
}

class FakeTimerFactory: TimerFactoryProtocol {
    private let _timer: FakeTimer
    init(timer: FakeTimer) {
        _timer = timer
    }
    func newTimerWithInterval(interval: TimeInteval) -> TimerProtocol {
        return _timer
    }
}
