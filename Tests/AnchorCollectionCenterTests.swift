// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align


class AnchorCollectionCenterTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testAlign() {
        XCTAssertEqualConstraints(
            view.anchors.center.align(with: container.anchors.center),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)]
        )
    }

    func testAlignWithSuperview() {
        XCTAssertEqualConstraints(
            view.anchors.center.alignWithSuperview(),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)]
        )
    }
}
