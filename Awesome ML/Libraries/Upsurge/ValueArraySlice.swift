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

/// A slice of a `ValueArray`. Slices not only specify start and end indexes, they also specify a step size.
public struct ValueArraySlice<Element: Value>: MutableLinearType, CustomStringConvertible, Equatable {
    public typealias Index = Int
    public typealias IndexDistance = Int
    public typealias Slice = ValueArraySlice<Element>
    public typealias Base = ValueArray<Element>

    public let base: Base
    public let baseStartIndex: Index
    public let baseEndIndex: Index
    public let step: IndexDistance

    public var startIndex: Index {
        return 0
    }

    public var endIndex: Index {
        return (baseEndIndex - baseStartIndex + step - 1) / step
    }

    public var span: Span {
        return Span(ranges: [startIndex ..< endIndex])
    }

    public func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafeBufferPointer { p in
            return try body(UnsafeBufferPointer<Element>(rebasing: p[baseStartIndex ..< baseEndIndex]))
        }
    }

    public func withUnsafePointer<R>(_ body: (UnsafePointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafePointer { p in
            return try body(p + baseStartIndex)
        }
    }

    public func withUnsafeMutableBufferPointer<R>(_ body: (UnsafeMutableBufferPointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafeMutableBufferPointer { p in
            return try body(UnsafeMutableBufferPointer<Element>(rebasing: p[baseStartIndex ..< baseEndIndex]))
        }
    }

    public func withUnsafeMutablePointer<R>(_ body: (UnsafeMutablePointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafeMutablePointer { p in
            return try body(p + baseStartIndex)
        }
    }

    public init(base: Base, startIndex: Index, endIndex: Index, step: IndexDistance) {
        assert(base.startIndex <= startIndex && endIndex <= base.endIndex)
        self.base = base
        self.baseStartIndex = startIndex
        self.baseEndIndex = endIndex
        self.step = step
    }

    public func assign<C: LinearType>(_ elements: C) where C.Element == Element {
        for (i, value) in zip(stride(from: baseStartIndex, to: baseEndIndex, by: step), elements) {
            base[i] = value
        }
    }

    public subscript(index: Index) -> Element {
        get {
            assert(index >= startIndex && index < endIndex)
            return base[baseStartIndex + index * step]
        }
        set {
            assert(index >= startIndex && index < endIndex)
            base[baseStartIndex + index * step] = newValue
        }
    }

    public subscript(intervals: [IntervalType]) -> Slice {
        get {
            assert(span.contains(intervals))
            assert(intervals.count == 1)
            let start = intervals[0].start ?? startIndex
            let end = intervals[0].end ?? endIndex
            return Slice(base: base, startIndex: start, endIndex: end, step: step)
        }
        set {
            assert(span.contains(intervals))
            assert(intervals.count == 1)
            let start = intervals[0].start ?? startIndex
            let end = intervals[0].end ?? endIndex
            for i in start..<end {
                self[i] = newValue[newValue.startIndex + i - start]
            }
        }
    }

    public subscript(intervals: [Int]) -> Element {
        get {
            assert(intervals.count == 1)
            return self[intervals[0]]
        }
        set {
            assert(intervals.count == 1)
            self[intervals[0]] = newValue
        }
    }

    public var description: String {
        return "[\(map({ $0.description }).joined(separator: ", "))]"
    }

    // MARK: - Equatable

    public static func == (lhs: ValueArraySlice, rhs: ValueArraySlice) -> Bool {
        return lhs.count == rhs.count && zip(lhs.indices, rhs.indices).all {
             lhs[$0] == rhs[$1]
        }
    }
}
