# Once

<p align="center">

[![Build Status](https://travis-ci.org/luoxiu/Once.svg?branch=master)](https://travis-ci.org/luoxiu/Once)
![release](https://img.shields.io/github/v/release/luoxiu/Once?include_prereleases)
![install](https://img.shields.io/badge/install-spm%20%7C%20cocoapods%20%7C%20carthage-ff69b4)
![platform](https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos%20%7C%20linux-lightgrey)
![license](https://img.shields.io/github/license/luoxiu/combinex?color=black)

</p>

Once 可以让你用直观的 API 管理任务的执行次数。

## Highlight

- [x] 安全
- [x] 高效
- [x] 持久化

## Usage

### Token

`Token` 在内存中记录任务的执行次数，它可以让任务在整个 app 生命期内只执行一次。

你可以把它看作 OC 中 `dispatch_once` 的替代品：

```objectivec
static dispatch_once_t token;
dispatch_once(&token, ^{
    // do something only once
});
```

使用 `Token` 的 swift 代码如下：

```swift
let token = Token.makeStatic()
token.do {
    // do something only once
}
```

或者，更简单一点：

```swift
Token.do {
    // do something only once
}
```

你也可以不用 `static`：

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

### PersistentToken

不同于 `Token`，`PersistentToken` 会持久化任务的执行历史（使用 `UserDefault`）。

`PersistentToken` 根据 `Scope` 和 `TimesPredicate` 判断是否应该执行本次任务。

#### Scope

`Scope` 表示时间范围。它是一个枚举：

- `.install`: 从应用安装到现在
- `.version`: 从应用升级到现在
- `.session`: 从应用启动到现在
- `.since(let since)`: 从 since 到现在
- `.until(let until)`: 从开始到 until

#### TimesPredicate

`TimesPredicate` 表示次数范围。

```swift
let p0 = TimesPredicate.equalTo(1)
let p1 = TimesPredicate.lessThan(1)
let p2 = TimesPredicate.moreThan(1)
let p3 = TimesPredicate.lessThanOrEqualTo(1)
let p4 = TimesPredicate.moreThanOrEqualTo(1)
```

#### do

你可以使用 `Scope` 和 `TimesPredicate` 组合成任意你想要的计划，而这，同样是线程安全的。

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

有时，你的异步任务可能会失败，你并不想把失败的任务标记为 done，你可以：

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

要提醒的是，这时的判断就不再是绝对安全的了——如果有多个线程同时检查该 token 的话，但这应该很少发生，😉。

#### reset

你还可以清除一个任务的执行历史：

```swift
token.reset()
```

清除所有任务的执行历史也是允许的，但要后果自负：

```swift
PersistentToken.resetAll()
```

## 安装

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

## 贡献

遇到一个 bug？想要更多的功能？尽管开一个 issue 或者直接提交一个 pr 吧！