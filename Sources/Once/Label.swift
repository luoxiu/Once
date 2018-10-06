public struct Label: RawRepresentable {

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

extension Label: Hashable {

    public var hashValue: Int {
        return rawValue.hashValue
    }

    public static func == (lhs: Label, rhs: Label) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
