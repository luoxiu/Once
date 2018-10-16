public func run(_ token: Token, block: () -> Void) {
    token.run(block)
}

public func run(dso: UnsafeRawPointer = #dsohandle,
                file: String = #file,
                line: Int = #line,
                column: Int = #column,
                function: String = #function,
                block: () -> Void) {
    let token = makeToken(dso: dso, file: file, line: line, column: column, function: function)
    run(token, block: block)
}
