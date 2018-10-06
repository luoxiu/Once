public func run(_ token: Token, block: () -> Void) {
    token.run(block)
}

public func run(block: () -> Void) {
    run(makeToken(), block: block)
}
