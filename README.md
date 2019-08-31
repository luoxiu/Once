# Once([简体中文](README.zh_cn.md))

<p align="center">

[![Build Status](https://travis-ci.org/luoxiu/Once.svg?branch=master)](https://travis-ci.org/luoxiu/Once)
[![codecov](https://codecov.io/gh/luoxiu/Once/branch/master/graph/badge.svg)](https://codecov.io/gh/luoxiu/Once)
![release](https://img.shields.io/github/release-pre/luoxiu/Once)
![install](https://img.shields.io/badge/install-spm%20%7C%20cocoapods%20%7C%20carthage-ff69b4)
![platform](https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos%20%7C%20linux-lightgrey)
![license](https://img.shields.io/github/license/luoxiu/combinex?color=black)

</div>

Once allows you to manage the number of executions of a task using an intuitive API.


## Highlight

- [x] Safe
- [x] Efficient
- [x] Persistent

## Usage

### Token

`Token` records the number of times the task is executed in memory, which allows the task to be executed only once during the entire lifetime of the app.

You can think of it as an alternative to `dispatch_once` in OC:

```objectivec
static dispatch_once_t token;
dispatch_once(&token, ^{
    // do something only once
});
```

The swift code using `Token` is as follows:

```swift
let token = Token.makeStatic()
token.do {
    // do something only once
}
```

Or, more simple：

```swift
Token.do {
    // do something only once
}
```

You can also don't use `static`:

```swift
class Manager {
    let loadToken = Token.make()

    func ensureLoad() {
        loadToken.do {
            // do something only once per manager.
        }
    }
}
```

### Do

Unlike `run`, `do` will persist the execution history of the task (using `UserDefault`).

`PersistentToken` determines whether this task should be executed based on `Scope` and `TimesPredicate`.

#### Scope

`Scope` represents a time range, it is an enum:

- `.install`: from app installation
- `.version`: from app update
- `.session`: from app launch
- `.since(let since)`: from `since(Date)`
- `.until(let until)`: to `until(Date)`

#### TimesPredicate

`TimesPredicate` represents a range of times.

```swift
let p0 = TimesPredicate.equalTo(1)
let p1 = TimesPredicate.lessThan(1)
let p2 = TimesPredicate.moreThan(1)
let p3 = TimesPredicate.lessThanOrEqualTo(1)
let p4 = TimesPredicate.moreThanOrEqualTo(1)
```

#### do

You can use `Scope` and `TimesPredicate` to make any plan you want, and, yes, it is thread-safe.

```swift
let token = PersistentToken.make("showTutorial")
token.do(in: .version, if: .equalTo(0)) {
    app.showTutorial()
}

// or
let later = 2.days.later
token.do(in: .until(later), if: .lessThan(5)) {
    app.showTutorial()
}
```

#### done

Sometimes your asynchronous task may fail. You don't want to mark the failed task as done. You can:

```swift
let token = PersistentToken.make("showAD")
token.do(in: .install, if: .equalTo(0)) { task in
    networkService.fetchAD { result in
        if result.isSuccess {
            showAD(result)
            task.done()
        }
    }
}
```

But at this time, the judgment is no longer absolutely safe - if there are multiple threads checking the token at the same time, but it should rarely happen, 😉.

#### reset

You can also clear the execution history of a task:

```swift
token.reset()
```

It is also permissible to clear the execution history of all tasks, but at your own risk:

```swift
PersistentToken.resetAll()
```

## Installation

### CocoaPods

```ruby
pod 'Once', '~> 1.0.0'
```

### Carthage

```ruby
github "luoxiu/Once" ~> 1.0.0
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/luoxiu/Once", .upToNextMinor(from: "1.0.0"))
]
```

## Contributing

Encounter a bug? want more features? Feel free to open an issue or submit a pr directly!
