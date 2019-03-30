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
    public static let defaultValue = 36.6
    
    let temperature: Double
    
    init(temperature: Double = defaultValue) {
        self.temperature = temperature
    }
    
    func todayTemperature() -> Double {
        return temperature
    }
}

class OptionalWeatherService: WeatherServiceProtocol {
    let temperature: Double?
    
    init(temperature: Double?) {
        self.temperature = temperature
    }
    
    func todayTemperature() -> Double {
        return temperature ?? 0
    }
}

class Weatherman {
    fileprivate let _weatherService: WeatherServiceProtocol
    init(weatherService: WeatherServiceProtocol) {
        _weatherService = weatherService
    }
    
    func say() -> String {
        return "Today`s temperature is \(_weatherService.todayTemperature())."
    }
}

class TestFatalErrorNotifier: FatalErrorNotifierProtocol {
    fileprivate var lastMessage: String!
    
    func notify(_ message: String) {
        lastMessage = message
    }
    
    func assertNotErrors(_ file: StaticString = #file, line: UInt = #line) {
        XCTAssertNil(lastMessage, "Should not raise any errors")
    }
    
    func assertLastMessage(_ message: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(lastMessage!, message, file: file, line: line)
    }
}


class EmptyTestModule: Module {
    override func load() {
    }
}

protocol ServiceProtocol: class {
    func send()
}

class Service: ServiceProtocol {
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
    
    func create(_ args: [Any]) -> Any {
        wasCalled = true
        return dependency.create(args)
    }
}

class FakeTimer: TimerProtocol {
    var delegate: TimerDelelgate?
    
    func timeout() {
        delegate?.onTick()
    }
    
    var startWasCalledTimes: Int = 0
    func start() {
        startWasCalledTimes += 1
    }
    
    var stopWasCalledTimes: Int = 0
    func stop() {
        stopWasCalledTimes += 1
    }
    
    func assertStartWasCalledTimes(_ times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(startWasCalledTimes == times, "Expected start() to be called \(times). But was called \(startWasCalledTimes).", file: file, line: line)
    }
    
    func assertStopWasCalledOnce(_ file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(stopWasCalledTimes == 1, "Expected stop() to be called once. But was called \(startWasCalledTimes).", file: file, line: line)
    }
}

class FakeTimerFactory: TimerFactoryProtocol {
    fileprivate let _timer: FakeTimer
    init(timer: FakeTimer) {
        _timer = timer
    }
    func newTimerWithInterval(_ interval: PainlessInjection.TimeInterval) -> TimerProtocol {
        return _timer
    }
}

class ModuleWithDependency : Module {
    var dependency: Dependency!
    override func load() {
        define(String.self) { "Hello" } . decorate { dependency in
            self.dependency = dependency
            return dependency
        }
    }
    
    func assertDependencyType(_ type: Any.Type, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(dependency.type == type, "Type should be String but got \(dependency.type)", file: file, line: line)

    }
}

class FakeTimerDelegate: TimerDelelgate {
    
    fileprivate  var calls: Int = 0
    
    func onTick() {
        calls += 1
    }
    
    func assertCallOnTickOnce(_ file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(calls == 1, "Expected onTick to be called once. But was called \(calls).", file: file, line: line)
    }
}

class FakeNSTimer: Foundation.Timer {
    var spyTarget: AnyObject
    var spySelector: Selector
    var spyFireDate: Date
    var spyInterval: Foundation.TimeInterval
    
    override init(fireAt date: Date, interval ti: Foundation.TimeInterval, target t: Any, selector s: Selector, userInfo ui: Any?, repeats rep: Bool) {
        self.spyTarget = t as AnyObject
        self.spySelector = s
        self.spyFireDate = date
        self.spyInterval = ti
        super.init(fireAt: date, interval: ti, target: t, selector: s, userInfo: ui, repeats: rep)
    }
    
    var fireWasCalledTimes: Int = 0
    override func fire() {
        fireWasCalledTimes += 1
        
        //        self.spyTarget.performSelector(self.spySelector)
        
    }
    func assertFireWasCallTimes(_ times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(fireWasCalledTimes == times, "Expected fire() to be called \(times). But was called \(fireWasCalledTimes).", file: file, line: line)
    }
    
    var invalidateWasCalledTimes: Int = 0
    override func invalidate() {
        invalidateWasCalledTimes += 1
    }
    func assertInvalidateCallTimes(_ times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(invalidateWasCalledTimes == times, "Expected fire() to be called \(times). But was called \(invalidateWasCalledTimes).", file: file, line: line)
    }
}
