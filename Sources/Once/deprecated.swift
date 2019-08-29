@available(*, deprecated, renamed: "Token.makeStatic")
public func makeToken(
    dso: UnsafeRawPointer = #dsohandle,
    file: String = #file,
    line: Int = #line,
    column: Int = #column,
    function: String = #function
)
    -> Token
{
    return Token.makeStatic(file: file, line: line, column: column)
}
