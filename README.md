[![Build Status](https://travis-ci.org/yaroslav-zhurakovskiy/PainlessInjection.svg?branch=master)](https://travis-ci.org/yaroslav-zhurakovskiy/PainlessInjection) [![codecov](https://codecov.io/gh/yaroslav-zhurakovskiy/PainlessInjection/branch/master/graph/badge.svg)](https://codecov.io/gh/yaroslav-zhurakovskiy/PainlessInjection)

# PainlessInjection
PainlessInjection is a lightweight dependency injection framework for Swift.

Dependency injection (DI) is a software design pattern that implements Inversion of Control (IoC) for resolving dependencies. In the pattern, PainlessInjection helps your app split into loosely-coupled components, which can be developed, tested and maintained more easily. PainlessInjection is powered by the Swift generic type system and first class functions to define dependencies of your app simply and fluently.

# Installation
PainlessInjection is avaialble via [Carthage](https://github.com/Carthage/Carthage), [CocoaPods](https://cocoapods.org/) or [Swift Package Manager](https://swift.org/package-manager/).
## Requirements
* iOS 8.0+
* Swift 5+
* Carthage 0.18+ (if you use)
* CocoaPods 1.1.1+ (if you use)
## Carthage
To install PainlessInjection with Carthage, add the following line to your Cartfile.
```
github "yaroslav-zhurakovskiy/PainlessInjection"
```
## CocoaPods
To install PainlessInjection with CocoaPods, add the following lines to your Podfile.
```ruby
pod "PainlessInjection"
```
## Swift Package Manager
You can use The Swift Package Manager to install PainlessInjection by adding the proper description to your Package.swift file:
```swift
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/yaroslav-zhurakovskiy/PainlessInjection.git", from: "1.3.0"),
    ]
)
```
# Usage
## Simple dependencies
```swift
import PainlessInjection

// Define Services
class ServiceModule: Module {
    override func load() {
        define(Service.self) { InMemmoryService() }
    }
}

// Load Modules
Container.load()
// Instantiate Service
let service = Container.get(type: Service.self)
// Using service
print(type(of: service))
```
## Swift 5.1 @propertyWrapper feature
If you use Swift 5.1 you can take advantage of concise form of autowiring. Just add @Inject attribute to your class/struct property, the framework will resolve everything for you.
```swift
// You service
enum AuthServiceError: Error {
    case serverIsDown
    case tooManyAttempts
}

protocol AuthService: class {
    func login(username: String, password: String, completion: @escaping (Result<Bool, AuthServiceError>) -> Void)
}

// Your controller that uses AuthService
class LoginController: UIViewController {
    // AuthService will be resolved automatically based on loaded modules
    @Inject var service: AuthService
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
     @IBAction func login() {
        service.login(
            username: usernameLabel.text ?? "",
            password: passwordLabel.text ?? ""
        )  { result in
            // Implement the logic
            // Redirect to home page
        }
    }
}


// Fake implementation that will enable you to test without the actual server
class FakeAuthService: AuthService {
    func login(username: String, password: String, completion: @escaping (Result<Bool, AuthServiceError>) -> Void) {
        guard username != "error" && password != "error" else {
            completion(.failure(AuthServiceError.serverIsDown))
            return
        }
        
        if username == "JohnDoe" && password == "132" {
            completion(.success(true))
        } else {
            completion(.success(false))
        }
    }
}

// Module with fake services
class TestModule: Module {
    func load() {
        define(AuthService.self) { FakeAuthService() } 
    }
}

// Loading and testing 
Container.load() // It will load TestModule
type(of: LoginController().service) == FakeAuthService.self // AuthService is automatically resolved to FakeAuthService 
```
## Dependencies with arguments and subdependencies
```swift
// Define Services
class ServiceModule: Module {
    override func load() {
        define(UserService.self) { RestUserService() }
    }
} 

// Define Controllers
class ControllersModule {
    override func load() {)
        define(ResetPasswordController.self) { args in
            ResetPasswordController(email: args.at(0), userService: self.resolve())
        }
    }
}

// Load Modules
Container.load()
// Instantiate ResetPasswordController
let controller = Container.get(type: ResetPasswordController.self, args: ["test@test.com"])
```
## Dependencies with optional arguments
```swift
// Define Services
class ServiceModule: Module {
    override func load() {
        define(TaskService.self) { RestTaskService() }
    }
} 

// Define Controllers
class ControllersModule {
    override func load() {)
        define(EditTaskController.self) { args in
            EditTaskController(task: args.optionalAt(0), service: self.resolve())
        }
    }
}

// Load Modules
Container.load()
// Passing nil
let controller2 = Container.get(type: EditTaskController.self, args: [nil as Any])
// Passing a task
let task = Task(name: "Code something")
let controller2 = Container.get(type: EditTaskController.self, args: [task])
```
## Using singletone scope
Very often you do not want to recreate a service every time. You want to use some kind of a singletone. In order to do it you can use singletone scope.
```swift
import PainlessInjection

class ServiceModule: Module {
    override func load() {
        define(Service.self) { InMemmoryService() }.inSingletonScope()
    }
}

// Use Service as a singletone
let service1 = Container.get(type: Service.self)
let service2 = Container.get(type: Service.self)
// service1 & service2 is the same object
service1 === service2
```
## Using cache scope
If you want to cache an object for some time you can use cache scope.
```swift
import PainlessInjection

class ServiceModule: Module {
    override func load() {
        // Service will be cached for 10 minutes.
        // After that it will be recreated again.
        define(Service.self) { InMemmoryService() }.inCacheScope(interval: 10 * 60)
    }
}

// Resolve Service type
let service1 = Container.get(type: Service.self)
let service2 = Container.get(type: Service.self)
// service1 & service2 is the same object
service1 === service2
// Wait for 10 minutes and 1 second
DispatchQueue.main.asyncAfter(deadline: .now() + 10 * 60 + 1) {
    let service3 = Container.get(type: Service.self)
    // service3 is different from service1 & service2
    service3 != service1 && service3 != service2
}
```
## Using decorators
You can add additional logic to the dependency creation process using decorators. 
For example you can log every time a dependency is resolved.
```swift
import PainlessInjection

class PrintableDependency: Dependency {
    private let original: Dependency
    
    init(original: Dependency) {
        self.original = original
    }
    
    var type: Any.Type {
        return original.type
    }
    
    func create(_ args: [Any]) -> Any {
        print("\(type) was created with", args, ".")
        return original.create(args)
    }
}

class UserModule: Module {
    override func load() {
        // Every time you will try to resolve User dependency it will be printed.
        define(User.self) { User() }.decorate({ PrintableDependency(original: $0) })
    }
}
```
## When to load dependencies
Put Container.load() somewhere in application:didFinishLaunchingWithOptions method of your AppDelegate class.
```swift
import PainlessInjection

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
        Container.load()
        print(Container.loadedModules) // prints a list of loaded Modules
        return true
     }
}
```
## Type inference
```swift
let service: Service = Container.get()
let user: User = Container.get("John", "Doe")
let anonymousUser: User = Container.get(nil as Any, nil as Any)
```
# Using different dependencies for different app versions
## Using preprocessor macros.
This module will be loaded only for debug builds.
```swift
import PainlessInjection

#if DEBUG
class DebugModule: Module {
    override func load() {
        define(Service.self) { InMemmoryService() }.inSingletonScope()
    }
}

#endif
```
This module will be loaded only for release builds.
```swift
import PainlessInjection

#if !DEBUG
class ReleaseModule: Module {
    override func load() {
        define(Service.self) { RestService() }.inSingletonScope()
    }
}

#endif
```
## Using LoadingPredicate.
Use "STORE_TARGET" environemnt variable to determine the app version.
```swift
import PainlessInjection
import Foundation

class StorePredicate: LoadModulePredicate {
    private let value: String
    
    init(valueMatching value: String) {
        self.value = value
    }
    
    func shouldLoadModule() -> Bool {
        guard let value = ProcessInfo.processInfo.environment["TARGET_STORE"] else {
            assertionFailure("No TARGET_STORE env var was found!")
        }
        
        return value == self.value
    }
}
```

This module will be loaded only if the app is running in the Canadian store.
```swift
class CanadianStoreModule: Module {
    override func load() {
        define(Service.self) { CanadaRestService() }.inSingletonScope()
    }
    
    override loadingPredicate() {
        return StorePredicate(valueMatching: "Canada")
    }
}
```

This module will be loaded only if the app is running in the USA store.
```swift
class USAStoreModule: Module {
    override func load() {
        define(Service.self) { USARestService() }.inSingletonScope()
    }
    
    override loadingPredicate() {
        return StorePredicate(valueMatching: "USA")
    }
}
```

Loading the service
```swift
Container.load()
let service = Container.get(type: Service.self)
print(type(of: service)) // Will print USAStoreModule or CanadaRestService
```
