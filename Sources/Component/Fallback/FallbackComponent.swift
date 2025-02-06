#if canImport(UIKit1)
import Foundation
import SwiftUI

/// Протокол для UIKit-компонентов.
///
/// В UIKit-компонентах данные и UI-представление разделены,
/// и данный протокол `FallbackComponent` используется для реализации слоя данных,
/// а для реализации UI-представления используется протокол `FallbackComponentView`, например:
///
/// ``` swift
/// /// Слой данных UIKit-компонента
/// struct Foo: FallbackComponent {
///
///     typealias UIView = FooView
///
///     let text: String
/// }
///
/// /// UI-представление UIKit-компонента
/// final class FooView: UIView {
///
///     private let label = UILabel()
///
///     override init(frame: CGRect) {
///         super.init(frame: frame)
///
///         setupLabel()
///     }
///
///     required init?(coder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
///
///     private func setupLabel() {
///         addSubview(label)
///
///         label.snp.makeConstraints { make in
///             make.edges.equalToSuperview()
///         }
///     }
/// }
///
/// extension FooView: FallbackComponentView {
///
///     static func sizing(
///         for content: Content,
///         fitting size: CGSize,
///         context: ComponentContext
///     ) -> ComponentSizing {
///         ComponentSizing(
///             width: .fill,
///             height: .hug
///         )
///     }
///
///     func update(
///         with content: Foo,
///         context: ComponentContext
///     ) {
///         label.text = content.text
///     }
/// }
/// ```
///
/// Так как определение размеров - это зона ответственности UI-представления,
/// то метод `sizing(for:fitting:context:)` реализуется именно в нем, а слой данных просто проксирует вызовы.
///
/// Любой UIKit-компонент, соответствующий этому протоколу `FallbackComponent`,
/// так же соответствует протоколу `Component`, поэтому так же может быть использован и в UIKit, и в SwiftUI.
///
/// В качестве UI-представления для SwiftUI используется отдельная сущность - `FallbackComponentBody`,
/// которая является универсальной реализацией протокола `UIViewRepresentable` для всех UIKit-компонентов.
///
/// - SeeAlso: ``FallbackComponentView``
/// - SeeAlso: ``FallbackComponentBody``
/// - SeeAlso: ``ComponentContext``
/// - SeeAlso: ``Component``
public protocol FallbackComponent: Component
where UIView: FallbackComponentView { }

extension FallbackComponent
where Body == FallbackComponentBody<Self> {

    public var body: Body {
        FallbackComponentBody<Self>(content: self)
    }
}

extension FallbackComponent {

    public func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        UIView.sizing(
            for: self,
            fitting: size,
            context: context
        )
    }
}
#endif
