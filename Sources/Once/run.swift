public func run(_ token: Token, block: () -> Void) {
    token.run(block)
}

public func run(
    file: String = #file,
    line: Int = #line,
    column: Int = #column,
    block: () -> Void)
{
    let token = Token.makeStatic(file: file, line: line, column: column)
    run(token, block: block)
}
