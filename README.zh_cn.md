# Once

<p align="center">

[![Build Status](https://travis-ci.org/jianstm/Once.svg?branch=master)](https://travis-ci.org/jianstm/Once)
[![codecov](https://codecov.io/gh/jianstm/Once/branch/master/graph/badge.svg)](https://codecov.io/gh/jianstm/Once)
<img src="https://img.shields.io/badge/version-0.0.1-orange.svg">
<img src="https://img.shields.io/badge/support-CocoaPods%20%7C%20Carthage%20%7C%20SwiftPM-brightgreen.svg">
<img src="https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-lightgrey.svg">
</p>

执行你的任务一次且仅一次。

## Features

- [x] 安全
- [x] 高效
- [x] 持久化
- [x] 极简
- [x] 直观

## Usage

### Run

`Once.run` 会在应用运行期间执行你的任务一次且仅一次，而且不需要提前初始化一个标识~ 😉

```swift
func initSomething() {
    Once.run {
        // 无论调用多少次 `initSomething`，都只会打印一次信息。
        // 多线程情境下，如果任务正在执行，后来的线程会等待任务执行结束。
        print("Once!")
    }
}
```

如果你希望在多个地方来判断同一个任务是否已经执行过了，可以使用 token：

```swift
var i = 0
let token = Once.makeToken()

// a.swift
Once.run(token) {
    i += 1
}

// b.swift
Once.run(token) {
    // 无论在多少地方调用都只会自增一次。
    i += 1
}
```

### Do

不同于 `run`，`do` 会持久化任务的执行历史（使用 `UserDefault`）。

在继续介绍 `do` 之前，先来认识几个非常简单的类型：

#### Period

`Period` 表示一个时间周期，它的常见用法如下：

```swift
let ago = Period.minute(30).ago  // 30 分钟前

let p0: Period = .year(1)
let p1: Period = .month(2)
let p2: Period = .day(3)

let p3 = p0 + p1 + p2
let later = p3.later
```

#### Scope

`Scope` 表示一个时间范围，它是一个枚举：

- `.install`: 从应用安装到现在
- `.version`: 从应用升级到现在
- `.session`: 从应用启动到现在
- `.since(let since)`: 从 since 开始
- `.until(let until)`: 到 until 为止
- `.every(let period)`: 每 period

让我们来看看 `do` 的 api：

```swift
let showTutorial = Label(rawValue: "show tutorial")
Once.do(showTutorial, scope: .version) { (sealer) in
    app.showTutorial()
    
    // 你总是需要调用 `seal` 来标记该 task 为已完成，不然这次执行不会被记录。
    // 与 `do` 一致的是，在多线程情境下，如果任务正在执行，后来的线程会等待任务执行结束。
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

// 清除任务的执行历史
Once.clear("pop ad")

// 最后一次的执行时间
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
