import UIKit
import Levitan
import SwiftUI

final class HomeViewController: UIViewController {

    var corners: CornersToken {
        CornersToken(
            topLeft: 100,
            topRight: 12,
            bottomLeft: 30,
            bottomRight: 30
        )
    }

    var stroke: StrokeToken {
        StrokeToken(
            type: .outside,
            width: 30,
            color: .init(color: .black.opacity(0.5))
        )
    }

    var innerShadow: ShadowToken {
        ShadowToken(
            type: .inner,
            color: .init(color: .black),
            offset: CGSize(width: 0, height: 12),
            blur: 24,
            spread: 0
        )
    }

    var dropShadow: ShadowToken {
        ShadowToken(
            type: .drop,
            color: .init(color: .black),
            offset: CGSize(width: 0, height: 12),
            blur: 24,
            spread: 0
        )
    }

    var gradient: GradientToken {
        GradientToken(
            colors: [
                .init(color: .red),
                .init(color: .green)
            ],
            startPoint: .zero,
            endPoint: CGPoint(x: 1, y: 1)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupFooView()
    }

    func setupFooView() {
        let foo = UIView()

        foo.frame  = CGRect(origin: .zero, size: CGSize(width: 300, height: 300))
        foo.center = view.center

        // Можно скруглить углы и установить тени без создания отдельного контейнера
        foo.tokens.corners = corners

        // Можно задать сразу несколько теней
        foo.tokens.shadows = [innerShadow, dropShadow]

        // Можно задать сразу несколько градиентов без добавления отдельного CAGradientLayer
        foo.tokens.gradients = [gradient]

        // Обводка так же может быть наружной, внутренней или центральной
        foo.tokens.stroke = stroke

        // Если задан corners или shape, то фоновый цвет следует устанавливать через shapeColor
        foo.tokens.shapeColor = 0xFF0000FF

        view.addSubview(foo)
    }

}
