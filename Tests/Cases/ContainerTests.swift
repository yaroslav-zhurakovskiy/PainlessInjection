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
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()

        Container.unload()
        FatalErrorNotifier.reset()
        Service.createdInstances = 0
    }

    func testShouldCreateNewDependencyModule() {
        class TestModule: Module {
            override func load() {
            }
        }
        _ = TestModule()

        XCTAssertTrue(true, "Test module was created")
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
        assertEqual(service.todayTemperature(), WeatherServce.defaultValue)
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
        assertEqual(service.todayTemperature(), 40)
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
        assertEqual(service.todayTemperature(), 40)
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
        assertEqual(service.todayTemperature(), 55.0)
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
        
        let service: WeatherServiceProtocol = Container.get(Any?.none)
        assertEqual(service.todayTemperature(), OptionalWeatherService.defaultValue)
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
        assertEqual(service.todayTemperature(), 60)
    }

    func testShouldThrowExceptionIfProtocolDependencyIsNotFound() {
        let module = EmptyTestModule()
        module.load()
        let notifier = FatalErrorNotifierMock()
        FatalErrorNotifier.currentNotifier = notifier

        let _: WeatherServiceProtocol! = Container.get()
        let file = #file
        let line = #line - 2

        notifier.assertLastMessage(
            missingDependencyType: WeatherServiceProtocol.self,
            inFile: file,
            atLine: line
        )
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

    func testShouldResolveTypeWithOneParam() {
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
    
    func testShouldResolveTypeWithMultipleParams() {
        class TestModule: Module {
            override func load() {
                define(WeathermanClient.self) {
                    let weatherman: NamedWetherman = self.resolve("Bob", WeatherServce(temperature: 60))
                    return WeathermanClient(weatherman: weatherman)
                }
                define(NamedWetherman.self) { args in NamedWetherman(name: args.at(0), weatherService: args.at(1)) }
                define(WeatherServiceProtocol.self) { args in WeatherServce(temperature: args.at(0)) }
            }
        }
        let module = TestModule()
        module.load()
        
        let client: WeathermanClient = Container.get()
        XCTAssertEqual(client.testSay(), "Bob says: Today`s temperature is 60.0.")
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
            var decorator: DependencySpy!

            override func load() {
                define(ServiceProtocol.self) { Service() } . decorate { dependency in
                    self.decorator = DependencySpy(dependency: dependency)
                    return self.decorator
                }
            }
        }
        let module = TestModule()
        module.load()

        let _: ServiceProtocol = Container.get()

        XCTAssertEqual(module.decorator.numberOfCreationCalls, 1, "Should decorate dependency")
    }

    func testShouldReturnDefineConfigurator() {
        class TestModule: Module {
            var configurator: DefineDependencyStatement<WeatherServiceProtocol>!
            override func load() {
                configurator = define(WeatherServiceProtocol.self) { args in
                    WeatherServce(temperature: args.at(0))
                }
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
    
    func testSholdResolveTypeUsingTypeParam() {
        class TestModule: ModuleWithDependency {
            override func load() {
                define(String.self) { "Hello" }
                define(WeatherServiceProtocol.self) { args in
                    WeatherServce(temperature: args.at(0))
                }
            }
        }
        let module = TestModule()
        module.load()
        
        let string: String = Container.get(type: String.self)
        let service = Container.get(type: WeatherServiceProtocol.self, args: [10.0])
        
        XCTAssertEqual(string, "Hello")
        assertEqual(service.todayTemperature(), 10)
    }
}
