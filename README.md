# Once([简体中文](README.zh_cn.md))

<div align="center">

<a href="https://travis-ci.org/jianstm/Once">
  <img src="https://travis-ci.org/jianstm/Once.svg?branch=master">
</a>
<a href="https://codecov.io/gh/jianstm/Once">
  <img src="https://codecov.io/gh/jianstm/Once/branch/master/graph/badge.svg">
</a>
<img src="https://img.shields.io/badge/version-0.0.2-orange.svg">
<img src="https://img.shields.io/badge/support-CocoaPods%20%7C%20Carthage%20%7C%20SwiftPM-brightgreen.svg">
<img src="https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-lightgrey.svg">

<br>
<br>
<br>
<strong>Executes your task once and only once.</strong>
</div>


## Highlight

- [x] Safe
- [x] Efficient
- [x] Persistent
- [x] Minimalist
- [x] Intuitive

## Usage

### Run

`Once.run`  will execute your task once and only once during the lifetime of application, and no need to initialize a flag in advance~ 😉

```swift
func doSomethingOnlyOnce() {
    Once.run {
        // No matter how many times `doSomethingOnlyOnce` is called, 
        // the message will only be printed once.
        // In multithreading, if the task is executing, 
        // the subsequent thread will wait for the execution ends.
        print("Once!")
    }
}
```

If you want to judge if the same task has already been executed elsewhere, you can use `token`:

```swift
var i = 0
let token = Once.makeToken()

// a.swift
Once.run(token) {
    i += 1
}

// b.swift
Once.run(token) {
    // No matter how many places it is called, the variable will only increment once.
    i += 1
}
```

### Do

Unlike `run`, `do` will persist the execution history of the task (using `UserDefault`).

Before moving on to `do`, let's get to know a few simple concepts:

#### Period

`Period` represents a time period, its common usage is as follows:

```swift
let ago = Period.minute(30).ago  // 30 minutes ago

let p0: Period = .year(1)
let p1: Period = .month(2)
let p2: Period = .day(3)

let p3 = p0 + p1 + p2
let later = p3.later
```

#### Scope

`Scope` represents a time range, it is an enum:

- `.install`: from app installation
- `.version`: from app update
- `.session`: from app launch
- `.since(let since)`: from `since(Date)`
- `.until(let until)`: to `until(Date)`
- `.every(let period)`: every `period(Period)`

Let's take a look at `do`:

```swift
let showTutorial = Label(rawValue: "show tutorial")

Once.do(showTutorial, scope: .version) { (sealer) in
    app.showTutorial()
    
    // You always need to call `seal` to mark the task as done, 
    // otherwise the execution will not be logged.
    // Same as `do`, in multithreading, if the task is executing, 
    // the subsequent thread will wait for the execution ends.
    sealer.seal() 
}

Once.if("remind", scope: .session, times: .lessThan(3)) { (sealer) in
    app.remind()
    sealer.seal()
}

Once.unless("pop ad", scope: .session, times: .equalTo(5)) { (sealer) in
    app.popAd()
    sealer.seal()
}

// Clear the history of the task.
Once.clear("pop ad")

// Date of the last execution.
Once.lastDone(of: "pop ad")
```

## Installation

### CocoaPods

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
  pod 'Once', '~> 0.0.1'
end
```

### Carthage

```ruby
github "jianstm/Once" ~> 0.0.1
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/jianstm/Once", .upToNextMinor(from: "0.0.1"))
]
```

## Contributing

Encounter a bug? want more features? Feel free to open an issue or submit a pr directly!