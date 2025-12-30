import UIKit
import SwiftUI
import Levitan

//class MyComponentView: UIView {
//
//    let titleLabel = UILabel()
//    let tagsView = UIStackView()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setupTitleLabel()
//        setupTagsView()
//    }
//
//    @available(*, unavailable)
//    public required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupTitleLabel() {
//        addSubview(titleLabel)
//
//        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
//        titleLabel.textAlignment = .center
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let constraints = [
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
//        ]
//
//        NSLayoutConstraint.activate(constraints)
//    }
//
//    func setupTagsView() {
//        addSubview(tagsView)
//
//        tagsView.alignment = .center
//        tagsView.axis = .horizontal
//        tagsView.spacing = 8
//        tagsView.translatesAutoresizingMaskIntoConstraints = false
//
//        let constraints = [
//            tagsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            tagsView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            tagsView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            tagsView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ]
//
//        NSLayoutConstraint.activate(constraints)
//    }
//
//    func updateTitle(with title: String) {
//        titleLabel.text = title
//    }
//
//    func updateTags(with tags: [String]) {
//        tagsView
//            .arrangedSubviews
//            .forEach { $0.removeFromSuperview() }
//
//        tags.forEach { tag in
//            let tagLabel = UILabel()
//
//            tagLabel.font = .preferredFont(forTextStyle: .title2)
//            tagLabel.text = tag
//
//            tagsView.addArrangedSubview(tagLabel)
//        }
//    }
//}

class ViewController: UIViewController {

//    let listView = VerticalList.UIView()
//    let componentView = MyComponentView()
//
//    var list = VerticalList.empty {
//        didSet { listView.update(with: list, context: context) }
//    }
//
//    var context: ComponentContext {
//        ComponentContext
//            .default
//            .componentViewController(self)
//            .componentContainerSize(view.bounds.size)
//    }
//
//    private func setupListView() {
//        view.addSubview(listView)
//
//        listView.contentInsetAdjustmentBehavior = .always
//
//        listView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    private func setupComponentView() {
//        view.addSubview(componentView)
//
//        componentView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.leading.greaterThanOrEqualToSuperview()
//            make.trailing.lessThanOrEqualToSuperview()
//        }
//    }
//
//    private func testUpdateWithoutChanges() {
//        list = VerticalList {
//            ListSection(
//                identifier: 0,
//                items: (0..<1).map { index in
//                    Foo(title: "Cell: 0 - \(index)", color: .lightGray)
//                        .listItem(identifier: "0-\(index)")
//                }
//            )
//            .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).listHeader())
//            .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).listFooter())
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(
//                    identifier: 0,
//                    items: (0..<1).map { index in
//                        Foo(title: "Cell: 0 - \(index)", color: .lightGray)
//                            .listItem(identifier: "0-\(index)")
//                    }
//                )
//                .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).listHeader())
//                .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).listFooter())
//            }
//        }
//    }
//
//    private func testSectionReloading() {
//        list = VerticalList {
//            ListSection(
//                identifier: 0,
//                items: (0..<1).map { index in
//                    Foo(title: "Cell: 0 - \(index)", color: .lightGray)
//                        .listItem(identifier: "0-\(index)")
//                }
//            )
//            .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).listHeader())
////            .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).listFooter())
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(
//                    identifier: 0,
//                    items: (0..<1).map { index in
//                        Foo(title: "Cell: 0 - \(index)", color: .lightGray)
//                            .listItem(identifier: "0-\(index)")
//                    }
//                )
//                .header(Foo(title: "Header \n NEW", color: UIColor.blue.withAlphaComponent(0.75)).listHeader())
////                .footer(Foo(title: "Footer \n NEW", color: UIColor.green.withAlphaComponent(0.75)).listFooter())
//            }
//        }
//    }
//
//    private func testSectionInserting() {
//        list = VerticalList(sections: [])
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(
//                    identifier: 1,
//                    items: (0..<1).map { index in
//                        Foo(title: "Cell: 1 - \(index)", color: .lightGray)
//                            .listItem(identifier: "1-\(index)")
//                    }
//                )
//                .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).listHeader())
//            }
//        }
//    }
//
//    private func testSectionDeleting() {
//        list = VerticalList {
//            ListSection(
//                identifier: 0,
//                items: (0..<2).map { index in
//                    Foo(title: "Cell: 0 - \(index)", color: .lightGray)
//                        .listItem(identifier: "0-\(index)")
//                }
//            )
//
//            ListSection(
//                identifier: 1,
//                items: (0..<1).map { index in
//                    Foo(title: "Cell: 1 - \(index)", color: .lightGray)
//                        .listItem(identifier: "1-\(index)")
//                }
//            )
//            .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).listHeader())
//            .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).listFooter())
//
//            ListSection(
//                identifier: 2,
//                items: (0..<2).map { index in
//                    Foo(title: "Cell: 2 - \(index)", color: .lightGray)
//                        .listItem(identifier: "2-\(index)")
//                }
//            )
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(
//                    identifier: 0,
//                    items: (0..<2).map { index in
//                        Foo(title: "Cell: 0 - \(index)", color: .lightGray)
//                            .listItem(identifier: "0-\(index)")
//                    }
//                )
//
//                ListSection(
//                    identifier: 2,
//                    items: (0..<2).map { index in
//                        Foo(title: "Cell: 2 - \(index)", color: .lightGray)
//                            .listItem(identifier: "2-\(index)")
//                    }
//                )
//            }
//        }
//    }
//
//    private func testSectionMoving() {
//        list = VerticalList {
//            ListSection(
//                identifier: 0,
//                items: (0..<1).map { index in
//                    Foo(title: "Cell: 0 - \(index)", color: .lightGray)
//                        .listItem(identifier: "0-\(index)")
//                }
//            )
//            .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).listHeader())
//            .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).listFooter())
//
//            ListSection(
//                identifier: 1,
//                items: (0..<2).map { index in
//                    Foo(title: "Cell: 1 - \(index)", color: .lightGray)
//                        .listItem(identifier: "1-\(index)")
//                }
//            )
//
//            ListSection(
//                identifier: 2,
//                items: (0..<2).map { index in
//                    Foo(title: "Cell: 2 - \(index)", color: .lightGray)
//                        .listItem(identifier: "2-\(index)")
//                }
//            )
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(
//                    identifier: 1,
//                    items: (0..<2).map { index in
//                        Foo(title: "Cell: 1 - \(index)", color: .lightGray)
//                            .listItem(identifier: "1-\(index)")
//                    }
//                )
//
//                ListSection(
//                    identifier: 2,
//                    items: (0..<2).map { index in
//                        Foo(title: "Cell: 2 - \(index)", color: .lightGray)
//                            .listItem(identifier: "2-\(index)")
//                    }
//                )
//
//                ListSection(
//                    identifier: 0,
//                    items: (0..<1).map { index in
//                        Foo(title: "Cell: 0 - \(index)", color: .lightGray)
//                            .listItem(identifier: "0-\(index)")
//                    }
//                )
//                .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).listHeader())
//                .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).listFooter())
//            }
//        }
//    }
//
//    private func testItemReloading() {
//        list = VerticalList {
//            ListSection(identifier: 0) {
//                Foo(title: "Cell: 0 - 1", color: .lightGray)
//                    .listItem(identifier: "0-1")
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(identifier: 0) {
//                    Foo(title: "Cell: 0 - 1\n NEW", color: .lightGray)
//                        .listItem(identifier: "0-1")
//                }
//            }
//        }
//    }
//
//    private func testItemInserting() {
//        list = VerticalList {
//            ListSection(identifier: 0) {
//                Foo(title: "Cell: 0 - 0", color: .lightGray)
//                    .listItem(identifier: "0-0")
//
//                Foo(title: "Cell: 0 - 2", color: .lightGray)
//                    .listItem(identifier: "0-2")
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(identifier: 0) {
//                    Foo(title: "Cell: 0 - 0", color: .lightGray)
//                        .listItem(identifier: "0-0")
//
//                    Foo(title: "Cell: 0 - 1", color: .lightGray)
//                        .listItem(identifier: "0-1")
//
//                    Foo(title: "Cell: 0 - 2", color: .lightGray)
//                        .listItem(identifier: "0-2")
//                }
//            }
//        }
//    }
//
//    private func testItemDeleting() {
//        list = VerticalList {
//            ListSection(identifier: 0) {
//                Foo(title: "Cell: 0 - 0", color: .lightGray)
//                    .listItem(identifier: "0-0")
//
//                Foo(title: "Cell: 0 - 1", color: .lightGray)
//                    .listItem(identifier: "0-1")
//
//                Foo(title: "Cell: 0 - 2", color: .lightGray)
//                    .listItem(identifier: "0-2")
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(identifier: 0) {
//                    Foo(title: "Cell: 0 - 0", color: .lightGray)
//                        .listItem(identifier: "0-0")
//
//                    Foo(title: "Cell: 0 - 2", color: .lightGray)
//                        .listItem(identifier: "0-2")
//                }
//            }
//        }
//    }
//
//    private func testItemMoving() {
//        list = VerticalList {
//            ListSection(identifier: 0) {
//                Foo(title: "Cell: 0 - 0", color: .lightGray)
//                    .listItem(identifier: "0-0")
//
//                Foo(title: "Cell: 0 - 1", color: .lightGray)
//                    .listItem(identifier: "0-1")
//
//                Foo(title: "Cell: 0 - 2", color: .lightGray)
//                    .listItem(identifier: "0-2")
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(identifier: 0) {
//                    Foo(title: "Cell: 0 - 1", color: .lightGray)
//                        .listItem(identifier: "0-1")
//
//                    Foo(title: "Cell: 0 - 2", color: .lightGray)
//                        .listItem(identifier: "0-2")
//
//                    Foo(title: "Cell: 0 - 0", color: .lightGray)
//                        .listItem(identifier: "0-0")
//                }
//            }
//        }
//    }
//
//    private func testSwiftUIItemReloading() {
//        list = VerticalList {
//            ListSection(identifier: 0) {
//                Bar(title: "Cell: 0 - 0\n NEW \n NEW", color: .gray)
//                    .listItem(identifier: "0-0")
//            }
//        }
//
////        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
////            self.list = VerticalList {
////                ListSection(identifier: 0) {
////                    Bar(title: "Cell: 0 - 0 NEW \n NEW \n NEW", color: .gray)
////                        .listItem(identifier: "0-0")
////                }
////            }
////        }
//    }
//
//
//    private func testTextWithFrameReloading() {
//        list = VerticalList {
//            ListSection(identifier: 0) {
//                Text("Cell: 0 - 0")
//                    .frame(width: .fill)
//                    .listItem(identifier: "0-0")
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(identifier: 0) {
//                    Text("Cell: 0 - 0 NEW \n NEW")
//                        .frame(width: .fill)
//                        .listItem(identifier: "0-0")
//                }
//            }
//        }
//    }
//
//    private func testInsetsChanging() {
//        list = VerticalList {
//            ListSection(identifier: 1) {
//                Foo(title: "Cell: 0 - 0", color: .lightGray)
//                    .listItem(identifier: "1-0")
//
//                Foo(title: "Cell: 0 - 2", color: .lightGray)
//                    .listItem(identifier: "1-2")
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.list = VerticalList {
//                ListSection(identifier: 1) {
//                    Foo(title: "Cell: 0 - 0", color: .lightGray)
//                        .listItem(identifier: "1-0")
//
//                    Foo(title: "Cell: 0 - 2", color: .lightGray)
//                        .listItem(identifier: "1-2")
//                }
//            }
//            .insets(all: 16.0)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.tokens.themeScheme(nil)
//
//        setupComponentView()
//
//        componentView.updateTitle(with: "UIKit")
//        componentView.updateTags(with: ["Hello", "World"])
//
////        testSwiftUIItemReloading()
//    }
}
