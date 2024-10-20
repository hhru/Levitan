import Foundation

extension StrokeDecorator: TokenTraitProvider where Value == TypographyValue { }
extension StrokeDecorator: TextDecorator where Value == TypographyValue { }

extension Text2 {

    public func stroke(_ stroke: TypographyStrokeToken? = 1.0) -> Self {
        decorated(by: StrokeDecorator(stroke: stroke))
    }
}
