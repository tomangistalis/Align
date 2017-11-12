// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest


func test(_ title: String? = nil, _ closure: () -> Void) {
    closure()
}

func test<T>(_ title: String? = nil, with element: T, _ closure: (T) -> Void) {
    closure(element)
}

// MARK: Asserts

public func XCTAssertEqualConstraints(_ expected: [NSLayoutConstraint], _ received: [NSLayoutConstraint], file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(expected.count, received.count)

    var received = received
    for c in expected {
        let idx = received.index(where: {
            Constraint($0) == Constraint(c)
        })
        XCTAssertNotNil(idx, "Failed to find constraints: \(c)\n\nExpected: \(expected)\n\nReceived: \(received)")
        if let idx = idx {
            received.remove(at: idx)
        }
    }
}

public func XCTAssertEqualConstraints(_ expected: NSLayoutConstraint, _ received: NSLayoutConstraint, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqualConstraints(Constraint(expected), Constraint(received), file: file, line: line)
}

private func XCTAssertEqualConstraints<T: Equatable>(_ expected: T, _ received: T, file: StaticString = #file, line: UInt = #line) {
    print(diff(expected, received))
    XCTAssertTrue(expected == received, "Found difference for " + diff(expected, received).joined(separator: ", "), file: file, line: line)
}

// MARK: Constraints

extension NSLayoutConstraint {
    @nonobjc convenience init(item item1: Any, attribute attr1: NSLayoutAttribute, relation: NSLayoutRelation = .equal, toItem item2: Any? = nil, attribute attr2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: Float? = nil, id: String? = nil) {
        self.init(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        if let priority = priority { self.priority = UILayoutPriority(priority) }
        if let id = id { self.identifier = id }
    }
}

private struct Constraint: Equatable {
    let firstItem: AnyObject?
    let firstAttribute: String
    let secondItem: AnyObject?
    let secondAttribute: String
    let relation: NSLayoutRelation.RawValue
    let multiplier: CGFloat
    let constant: CGFloat
    let priority: UILayoutPriority.RawValue
    let identifier: String?

    init(_ c: NSLayoutConstraint) {
        firstItem = c.firstItem
        firstAttribute = c.firstAttribute.toString
        secondItem = c.secondItem
        secondAttribute = c.secondAttribute.toString
        relation = c.relation.rawValue
        multiplier = c.multiplier
        constant = c.constant
        priority = c.priority.rawValue
        identifier = c.identifier
    }

    static func ==(lhs: Constraint, rhs: Constraint) -> Bool {
        return lhs.firstItem === rhs.firstItem &&
            lhs.firstAttribute == rhs.firstAttribute &&
            lhs.relation == rhs.relation &&
            lhs.secondItem === rhs.secondItem &&
            lhs.secondAttribute == rhs.secondAttribute &&
            lhs.multiplier == rhs.multiplier &&
            lhs.constant == rhs.constant &&
            lhs.priority == rhs.priority &&
            lhs.identifier == rhs.identifier
    }
}

// MARK: Helpers

extension NSLayoutAttribute {
    var toString: String {
        switch self {
        case .width: return "width"
        case .height: return "height"
        case .bottom: return "bottom"
        case .bottomMargin: return "bottomMargin"
        case .top: return "top"
        case .topMargin: return "topMargin"
        case .left: return "left"
        case .leftMargin: return "leftMargin"
        case .right: return "right"
        case .rightMargin: return "rightMargin"
        case .leading: return "leading"
        case .leadingMargin: return "leadingMargin"
        case .trailing: return "trailing"
        case .trailingMargin: return "trailingMargin"
        case .centerX: return "centerX"
        case .centerXWithinMargins: return "centerXWithinMargins"
        case .centerY: return "centerY"
        case .centerYWithinMargins: return "centerYWithinMargins"
        case .lastBaseline: return "lastBaseline"
        case .firstBaseline: return "firstBaseline"
        case .notAnAttribute: return "notAnAttribute"
        }
    }
}
