public struct Label {

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Label: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

extension Label: Hashable { }
