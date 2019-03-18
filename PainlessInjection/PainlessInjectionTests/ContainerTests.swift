//
//  PainlessInjectorTests.swift
//  PainlessInjectorTests
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import XCTest
import PainlessInjection

class ContainerTests: XCTestCase {

    var timer: FakeTimer!

    override func setUp() {
        super.setUp()

        timer = FakeTimer()
        PainlessInjection.Timer.factory = FakeTimerFactory(timer: timer)

    }

    override func tearDown() {
        super.tearDown()

        Container.unload();
        FatalErrorNotifier.reset();
        Service.createdInstances = 0
        PainlessInjection.Timer.reset()
    }

    func testShouldCreateNewDependencyModule() {
        class TestModule: Module {
            override func load() {
            }
        }
        _ = TestModule()

        XCTAssertTrue(true, "Test module was created");
    }

    func testShouldAddDependency() {
        class TestModule: Module {
            override func load() {
                define(WeatherServiceProtocol.self) { WeatherServce() }
            }
        }
        let module = TestModule()
        module.load()

        let service: WeatherServiceProtocol = Container.get()
        XCTAssertEqual(service.todayTemperature(), 36.6)
    }

    func testShouldAddDependencyOnleOnce() {
        class TestModule: Module {
            override func load() {
                define(WeatherServiceProtocol.self) { WeatherServce(temperature: 40) }
                define(WeatherServiceProtocol.self) { WeatherServce(temperature: 50) }
            }
        }
        let module = TestModule()
        module.load()

        let service: WeatherServiceProtocol = Container.get()
        XCTAssertEqual(service.todayTemperature(), 40)
    }

    func testShouldAddDifferentDependencies() {
        class TestModule: Module {
            override func load() {
                define(WeatherServiceProtocol.self) {
                    WeatherServce(temperature: 40)
                }
                define(String.self) { "Hello" }
            }
        }
        let module = TestModule()
        module.load()

        let service: WeatherServiceProtocol = Container.get()
        let text: String = Container.get()
        XCTAssertEqual(service.todayTemperature(), 40)
        XCTAssertEqual(text, "Hello")
    }

    func testShouldGetDependenciesWithParams() {
        class TestModule: Module {
            override func load() {
                define(WeatherServiceProtocol.self) { args in WeatherServce(temperature: args.at(0)) }
            }
        }
        let module = TestModule()
        module.load()

        let service: WeatherServiceProtocol = Container.get(55.0)
        XCTAssertEqual(service.todayTemperature(), 55.0)
    }
    
    func testShouldGetDependenciesWithNilParams() {
        class TestModule: Module {
            override func load() {
                define(WeatherServiceProtocol.self) { args in
                    OptionalWeatherService(temperature: args.optionalAt(0))
                }
            }
        }
        let module = TestModule()
        module.load()
        
        let service: WeatherServiceProtocol = Container.get(Optional<Any>.none)
        XCTAssertEqual(service.todayTemperature(), 0)
    }
    
    func testShouldGetDependenciesWithNilParamsWhenNonNillIsPAssed() {
        class TestModule: Module {
            override func load() {
                define(WeatherServiceProtocol.self) { args in
                    OptionalWeatherService(temperature: args.optionalAt(0))
                }
            }
        }
        let module = TestModule()
        module.load()
        
        let service: WeatherServiceProtocol = Container.get(60.0)
        XCTAssertEqual(service.todayTemperature(), 60)
    }

    func testShouldThrowExceptionIfProtocolDependencyIsNotFound() {
        let module = EmptyTestModule()
        module.load()
        let notifier = TestFatalErrorNotifier()
        FatalErrorNotifier.currentNotifier = notifier

        let _: WeatherServiceProtocol! = Container.get()

        notifier.assertLastMessage("Could not find a dependency for type WeatherServiceProtocol.")
    }

    func testShouldResolveType() {
        class TestModule: Module {
            override func load() {
                define(WeatherServiceProtocol.self) { WeatherServce(temperature: 44) }
                define(Weatherman.self) { Weatherman(weatherService: self.resolve()) }
            }
        }
        let module = TestModule()
        module.load()

        let weatherman: Weatherman = Container.get()
        XCTAssertEqual(weatherman.say(), "Today`s temperature is 44.0.")
    }

    func testShouldResolveTypeIndependetlyOfDeclerationOrder() {
        class TestModule: Module {
            override func load() {
                define(Weatherman.self) { Weatherman(weatherService: self.resolve()) }
                define(WeatherServiceProtocol.self) { WeatherServce(temperature: 44) }
            }
        }
        let module = TestModule()
        module.load()

        let weatherman: Weatherman = Container.get()
        XCTAssertEqual(weatherman.say(), "Today`s temperature is 44.0.")
    }

    func testShouldResolveTypeWithParams() {
        class TestModule: Module {
            override func load() {
                define(Weatherman.self) { Weatherman(weatherService: self.resolve(60.0)) }
                define(WeatherServiceProtocol.self) { args in WeatherServce(temperature: args.at(0)) }
            }
        }
        let module = TestModule()
        module.load()

        let weatherman: Weatherman = Container.get()
        XCTAssertEqual(weatherman.say(), "Today`s temperature is 60.0.")
    }

    func testShouldCreateDependencyWithSingletonScope() {
        class TestModule: Module {
            override func load() {
                define(ServiceProtocol.self) { Service() } . inSingletonScope()
            }
        }
        let module = TestModule()
        module.load()

        let _: ServiceProtocol = Container.get()
        let _: ServiceProtocol = Container.get()

        XCTAssertEqual(Service.createdInstances, 1)
    }

    func testShouldWrapDependency() {
        class TestModule: Module {
            var decorator: DependencyDecorator!

            override func load() {
                define(ServiceProtocol.self) { Service() } . decorate { dependency in
                    self.decorator = DependencyDecorator(dependency: dependency)
                    return self.decorator
                }
            }
        }
        let module = TestModule()
        module.load()

        let _: ServiceProtocol = Container.get()

        XCTAssertTrue(module.decorator.wasCalled, "Should decorate dependency")
    }

    func testShouldCreateDependencyWithCachedScope() {
        class TestModule: Module {
            override func load() {
                define(Service.self) { Service() } . inCacheScope(interval: TimeInterval(seconds: 60))
            }
        }
        let module = TestModule()
        module.load()

        let s1: Service = Container.get()
        let s2: Service = Container.get()
        XCTAssertEqual(s1.id, 1, "Should have the same id until cache is valid")
        XCTAssertEqual(s2.id, 1, "Should have the same id until cache is valid")

        timer.assertStartWasCalledTimes(1)
        timer.timeout()
        timer.assertStopWasCalledOnce()

        let s3: Service = Container.get()
        XCTAssertEqual(s3.id, 2, "Should have a new service.")
        timer.assertStartWasCalledTimes(2)
    }

    func testShouldReturnDefineConfigurator() {
        class TestModule: Module {
            var configurator: DefineDependencyStatement!
            override func load() {
                configurator = define(WeatherServiceProtocol.self) { args in WeatherServce(temperature: args.at(0)) }
            }
        }
        let module = TestModule()
        module.load()

        XCTAssertNotNil(module.configurator)
    }
    
    func testWhenUseSimpleDependencyShouldReturnCorrectDependencyType() {
        class TestModule: ModuleWithDependency {
            override func load() {
                define(String.self) { "Hello" } . decorate { dependency in
                    self.dependency = dependency
                    return dependency
                }
            }
        }
        let module = TestModule()
        module.load()
        
        module.assertDependencyType(String.self)
    }
    
    func testWhenUseSingletoneScopeShouldReturnCorrectDependencyType() {
        class TestModule: ModuleWithDependency {
            override func load() {
                define(String.self) { "Hello" } . inSingletonScope() . decorate { dependency in
                    self.dependency = dependency
                    return dependency
                }
            }
        }
        let module = TestModule()
        module.load()
        
        module.assertDependencyType(String.self)
    }
    
    func testWhenUseCacheScopeShouldReturnCorrectDependencyType() {
        class TestModule: ModuleWithDependency {
            override func load() {
                define(String.self) { "Hello" } . inCacheScope(interval: TimeInterval(minutes: 1)) . decorate { dependency in
                    self.dependency = dependency
                    return dependency
                }
            }
        }
        let module = TestModule()
        module.load()
        
        module.assertDependencyType(String.self)
    }
}
