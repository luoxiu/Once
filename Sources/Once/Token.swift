import Foundation

public final class Token {

    private let isSealed = Atom(value: false)

    public func `do`(_ task: () -> Void) {
        isSealed.once_run(task)
    }
    
    public static func `do`(file: String = #file, line: Int = #line, column: Int = #column, _ task: () -> Void) {
        Token.makeStatic(file: file, line: line, column: column).do(task)
    }
}

extension Token {
    
    public static func make() -> Token {
        return Token()
    }
}

extension Token {
    
    private static let registry = Atom<[String: Token]>(value: [:])
    
    public static func makeStatic(
        file: String = #file,
        line: Int = #line,
        column: Int = #column
    )
        -> Token
    {
        let key = "\(file)-\(line)-\(column))"
        return registry.once_get(key, Token())
    }
}
