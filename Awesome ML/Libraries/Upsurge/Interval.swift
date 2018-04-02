// Copyright © 2015 Venture Media Labs.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

public protocol IntervalType {
    var start: Int? { get }
    var end: Int? { get }
}

public enum Interval: IntervalType, ExpressibleByIntegerLiteral {
    case all
    case range(CountableClosedRange<Int>)

    public init(range: CountableClosedRange<Int>) {
        self = Interval.range(range)
    }

    public init(integerLiteral value: Int) {
        self = Interval.range(value...value)
    }

    public var start: Int? {
        if case let .range(r) = self {
          return r.lowerBound
        }
        return nil
    }

    public var end: Int? {
        if case let .range(r) = self {
          return r.upperBound + 1
        }
        return nil
    }
}

extension CountableRange: IntervalType {
    public var start: Int? {
        return unsafeBitCast(lowerBound, to: Int.self)
    }

    public var end: Int? {
        return unsafeBitCast(upperBound, to: Int.self)
    }
}

extension CountableClosedRange: IntervalType {
    public var start: Int? {
        return unsafeBitCast(lowerBound, to: Int.self)
    }

    public var end: Int? {
        return unsafeBitCast(upperBound, to: Int.self) + 1
    }
}
