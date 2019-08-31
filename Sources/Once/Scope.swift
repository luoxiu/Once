import Foundation

public enum Scope {

    case install

    case version

    case session

    case since(Date)

    case until(Date)
}
