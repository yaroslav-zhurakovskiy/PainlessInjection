//
//  AutoinjectTests.swift
//  PainlessInjectionTests
//
//  Created by Yaroslav Zhurakovskiy on 04.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

#if swift(>=5.1)

import PainlessInjection
import XCTest

fileprivate let temperatureStub: Double = 36.6
fileprivate let optionalTemperatureStub: Double? = 66.9

fileprivate struct AutoinjecteServiceUser {
    @Inject var service: ServiceProtocol
    @Inject(temperatureStub) var weatherService: WeatherServiceProtocol
    @Inject(optionalTemperatureStub as Any) var optionalWeatherServiceWithStub: OptionalWeatherService
    @Inject(Optional<Double>.none) var optionalWeatherServiceWithoutStub: OptionalWeatherService
}

class AutoinjectTests: XCTestCase {
    
    var errorNotifier: FatalErrorNotifierMock!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        class TestModule: Module {
            override func load() {
                define(ServiceProtocol.self) { Service() }
                define(WeatherServiceProtocol.self) { WeatherServce(temperature: $0.at(0)) }
                define(OptionalWeatherService.self) { OptionalWeatherService(temperature: $0.optionalAt(0))}
            }
        }

        TestModule().load()
        errorNotifier = FatalErrorNotifierMock()
        FatalErrorNotifier.currentNotifier = errorNotifier
    }
    
    override class func tearDown() {
        Container.unload()
        FatalErrorNotifier.reset()
        
        super.tearDown()
    }

    func testAutowiring() {
        let user = AutoinjecteServiceUser()
        
        XCTAssertTrue(user.service is Service, "service must be autowired to \(Service.self) but got \(type(of: user.service))")
    }
    
    func testAutowiringWithParameters() {
        let user = AutoinjecteServiceUser()
        
        XCTAssertTrue(user.weatherService is WeatherServce, "service must be autowired to \(WeatherServce.self) but got \(type(of: user.service))")
        AssertEqual(user.weatherService.todayTemperature(), temperatureStub)
    }
    
    func testAutowiringWithOptionalParametersPresent() {
        let user = AutoinjecteServiceUser()
        
        AssertEqual(user.optionalWeatherServiceWithStub.todayTemperature(), optionalTemperatureStub!)
    }
    
    func testAutowiringWithOptionalParametersMissing() {
        let user = AutoinjecteServiceUser()
        
        AssertEqual(user.optionalWeatherServiceWithoutStub.todayTemperature(), OptionalWeatherService.defaultValue)
    }
}


#endif
