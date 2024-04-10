import SwiftUI
import Combine

// TODO: Добавить документацию
@dynamicMemberLookup
@propertyWrapper
public struct ViewObservedObject<Value: ObservableObject>: CustomStringConvertible {

    public let wrappedValue: Value

    public var projectedValue: Self {
        self
    }

    public var description: String {
        String(describing: wrappedValue)
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public subscript<Subject>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            getter: { wrappedValue[keyPath: keyPath] },
            setter: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }
}
