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
    static let defaultValue: Double = -1.0
    
    let temperature: Double?
    
    init(temperature: Double?) {
        self.temperature = temperature
    }
    
    func todayTemperature() -> Double {
        return temperature ?? Self.defaultValue
    }
}

class Weatherman {
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func say() -> String {
        return "Today`s temperature is \(weatherService.todayTemperature())."
    }
}

class FatalErrorNotifierMock: FatalErrorNotifierProtocol {
    private var lastMessage: String!
    
    func notify(_ message: String) {
        lastMessage = message
    }
    
    func assertNotErrors(_ file: StaticString = #file, line: UInt = #line) {
        XCTAssertNil(lastMessage, "Should not raise any errors")
    }
    
    func assertLastMessage(_ message: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(lastMessage, "No messages were notified.", file: file, line: line)
        XCTAssertEqual(lastMessage!, message, file: file, line: line)
    }
    
    func assertLastMessage<Expected, Received>(
        expectedType: Expected.Type,
        receivedType: Received.Type,
        parameterIndex: Int,
        inFile: String,
        atLine: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let lastMessage =
            "Expected \(expectedType) parameter" +
            " at index \(parameterIndex)" +
            " but got \(receivedType): file \(inFile), line \(atLine)"
        assertLastMessage(lastMessage, file: file, line: line)
    }
    
    func assertLastmessage<Expected>(
        expectedType: Expected.Type,
        parameterIndex: Int,
        inFile: String,
        atLine: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let lastMessage =
            "Expected \(expectedType) parameter" +
            " at index \(parameterIndex)" +
            " but got nothing: file \(inFile), line \(atLine)"
        assertLastMessage(lastMessage, file: file, line: line)
    }
    
    func assertLastMessage<T>(
        missingDependencyType type: T.Type,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertLastMessage("Could not find a dependency for type \(type).", file: file, line: line)
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
    weak var delegate: TimerDelelgate?
    
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
        XCTAssertTrue(
            startWasCalledTimes == times,
            "Expected start() to be called \(times). But was called \(startWasCalledTimes).",
            file: file,
            line: line
        )
    }
    
    func assertStopWasCalledOnce(_ file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(
            stopWasCalledTimes == 1,
            "Expected stop() to be called once. But was called \(startWasCalledTimes).",
            file: file,
            line: line
        )
    }
}

class FakeTimerFactory: TimerFactoryProtocol {
    private let timer: FakeTimer
    
    init(timer: FakeTimer) {
        self.timer = timer
    }
    func newTimerWithInterval(_ interval: PainlessInjection.TimeInterval) -> TimerProtocol {
        return timer
    }
}

class ModuleWithDependency: Module {
    var dependency: Dependency!
    override func load() {
        define(String.self) { "Hello" } . decorate { dependency in
            self.dependency = dependency
            return dependency
        }
    }
    
    func assertDependencyType(_ type: Any.Type, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(
            dependency.type == type,
            "Type should be String but got \(dependency.type)",
            file: file,
            line: line
        )

    }
}

class FakeTimerDelegate: TimerDelelgate {
    
    private  var calls: Int = 0
    
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
    
    override init(
        fireAt date: Date,
        interval: Foundation.TimeInterval,
        target: Any,
        selector: Selector,
        userInfo: Any?,
        repeats: Bool
    ) {
        self.spyTarget = target as AnyObject
        self.spySelector = selector
        self.spyFireDate = date
        self.spyInterval = interval
        super.init(
            fireAt: date,
            interval: interval,
            target: target,
            selector: selector,
            userInfo: userInfo,
            repeats: repeats
        )
    }
    
    var fireWasCalledTimes: Int = 0
    override func fire() {
        fireWasCalledTimes += 1
    }
    func assertFireWasCallTimes(_ times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(
            fireWasCalledTimes == times,
            "Expected fire() to be called \(times). But was called \(fireWasCalledTimes).",
            file: file,
            line: line
        )
    }
    
    var invalidateWasCalledTimes: Int = 0
    override func invalidate() {
        invalidateWasCalledTimes += 1
    }
    func assertInvalidateCallTimes(_ times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(
            invalidateWasCalledTimes == times,
            "Expected fire() to be called \(times). But was called \(invalidateWasCalledTimes).",
            file: file,
            line: line
        )
    }
}
