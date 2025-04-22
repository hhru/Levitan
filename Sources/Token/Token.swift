import Foundation

@dynamicMemberLookup
public struct Token<Value>: TokenTraitProvider, Sendable {

    public let traits: [TokenTrait]

    private let resolver: @Sendable (_ theme: TokenTheme) -> Value

    internal init(
        traits: [TokenTrait],
        resolver: @escaping @Sendable (_ theme: TokenTheme) -> Value
    ) {
        self.traits = traits
        self.resolver = resolver
    }

    public init(
        traits: [TokenTraitProvider],
        resolver: @escaping @Sendable (_ theme: TokenTheme) -> Value
    ) {
        self.init(
            traits: traits.map { TokenTrait($0.traits) },
            resolver: resolver
        )
    }

    public init(
        trait: some Hashable & Sendable,
        resolver: @escaping @Sendable (_ theme: TokenTheme) -> Value
    ) {
        self.init(
            traits: [TokenTrait(trait)],
            resolver: resolver
        )
    }

    public init(resolver: @escaping @Sendable (_ theme: TokenTheme) -> Value) {
        self.init(
            traits: [] as [TokenTrait],
            resolver: resolver
        )
    }

    public func resolve(for theme: TokenTheme) -> Value {
        resolver(theme)
    }
}

extension Token: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard !lhs.traits.isEmpty, !rhs.traits.isEmpty else {
            return false
        }

        return lhs.traits == rhs.traits
    }
}

extension Token: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(traits)
    }
}

extension Token where Value: Hashable & Sendable {

    public static func value(_ value: Value) -> Self {
        Self(traits: [TokenTrait(value)]) { _ in
            value
        }
    }
}

extension Token where Value: Sendable {

    public subscript<Nested>(
        dynamicMember relativePath: KeyPath<Value, Nested> & Sendable
    ) -> Token<Nested> {
        Token<Nested>(traits: traits.appending(TokenTrait(relativePath))) { theme in
            resolve(for: theme)[keyPath: relativePath]
        }
    }

    public subscript<Nested>(
        dynamicMember relativePath: KeyPath<Value, Token<Nested>> & Sendable
    ) -> Token<Nested> {
        Token<Nested>(traits: traits.appending(TokenTrait(relativePath))) { theme in
            resolve(for: theme)[keyPath: relativePath].resolve(for: theme)
        }
    }
}

extension Token: ExpressibleByFloatLiteral
where Value: ExpressibleByFloatLiteral & TokenValue {

    public init(floatLiteral value: Value.FloatLiteralType) {
        self = .value(Value(floatLiteral: value))
    }
}

extension Token: ExpressibleByIntegerLiteral
where Value: ExpressibleByIntegerLiteral & TokenValue {

    public static var zero: Self {
        .value(0)
    }

    public init(integerLiteral value: Value.IntegerLiteralType) {
        self = .value(Value(integerLiteral: value))
    }
}

extension Token: ExpressibleByUnicodeScalarLiteral
where Value: ExpressibleByUnicodeScalarLiteral & TokenValue {

    public init(unicodeScalarLiteral value: Value.UnicodeScalarLiteralType) {
        self = .value(Value(unicodeScalarLiteral: value))
    }
}

extension Token: ExpressibleByExtendedGraphemeClusterLiteral
where Value: ExpressibleByExtendedGraphemeClusterLiteral & TokenValue {

    public init(extendedGraphemeClusterLiteral value: Value.ExtendedGraphemeClusterLiteralType) {
        self = .value(Value(extendedGraphemeClusterLiteral: value))
    }
}

extension Token: ExpressibleByStringLiteral
where Value: ExpressibleByStringLiteral & TokenValue {

    public init(stringLiteral value: Value.StringLiteralType) {
        self = .value(Value(stringLiteral: value))
    }
}

extension Token: ExpressibleByArrayLiteral
where Value: RangeReplaceableCollection & Hashable,
      Value.Element: Hashable {

    public init(arrayLiteral elements: Token<Value.Element>...) {
        let traits = elements.map { TokenTrait($0.traits) }

        self.init(traits: traits) { theme in
            Value(elements.map { $0.resolve(for: theme) })
        }
    }
}
