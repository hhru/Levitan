import Foundation

// TODO: Добавить документацию
@propertyWrapper
public struct ViewFocusBinding<Value: Hashable>: Hashable {

    @ViewBinding
    private var binding: Value

    public let canFocus: Bool
    public let canUnfocus: Bool

    public var wrappedValue: Value {
        get { binding }

        nonmutating set {
            if binding != newValue {
                binding = newValue
            }
        }
    }

    public var projectedValue: Self {
        self
    }

    private init(
        binding: ViewBinding<Value>,
        canFocus: Bool,
        canUnfocus: Bool
    ) {
        self._binding = binding

        self.canFocus = canFocus
        self.canUnfocus = canUnfocus
    }

    public init<Wrapped: Hashable>(binding: ViewBinding<Value>)
    where Value == Wrapped? {
        self.init(
            binding: binding,
            canFocus: true,
            canUnfocus: true
        )
    }

    public init(binding: ViewBinding<Value>)
    where Value == Bool {
        self.init(
            binding: binding,
            canFocus: true,
            canUnfocus: true
        )
    }

    public init(projectedValue: Self) {
        self = projectedValue
    }

    public func equating<Wrapped: Hashable>(to value: Wrapped) -> ViewFocusBinding<Bool>
    where Value == Wrapped? {
        let focusBinding = ViewBinding<Bool>(
            get: { binding == value },
            set: { isFocused in
                if isFocused {
                    binding = value
                } else if binding == value {
                    binding = nil
                }
            }
        )

        return ViewFocusBinding<Bool>(
            binding: focusBinding,
            canFocus: true,
            canUnfocus: self.binding == nil
        )
    }
}

extension ViewFocusBinding where Value == Bool {

    public static var unfocusable: Self {
        Self(
            binding: .constant(false),
            canFocus: false,
            canUnfocus: true
        )
    }
}
