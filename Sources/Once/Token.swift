import Foundation

public final class Token {

    private let isSealed = Atom(value: false)

    func run(_ task: () -> Void) {
        isSealed.once_run(task)
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
