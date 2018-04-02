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

public class ComplexArraySlice<T: Real>: MutableLinearType {
    public typealias Index = Int
    public typealias Element = Complex<T>
    public typealias Slice = ComplexArraySlice

    public let base: ComplexArray<T>
    public let baseStartIndex: Index
    public let baseEndIndex: Index
    public let step: Index

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

    public var reals: ComplexArrayRealSlice<T> {
        get {
            return ComplexArrayRealSlice(base: base, startIndex: startIndex, endIndex: 2*endIndex - 1, step: 2)
        }
        set {
            precondition(newValue.count == reals.count)
            for i in 0..<newValue.count {
                self.reals[i] = newValue[i]
            }
        }
    }

    public var imags: ComplexArrayRealSlice<T> {
        get {
            return ComplexArrayRealSlice(base: base, startIndex: startIndex + 1, endIndex: 2*endIndex, step: 2)
        }
        set {
            precondition(newValue.count == imags.count)
            for i in 0..<newValue.count {
                self.imags[i] = newValue[i]
            }
        }
    }

    public required init(base: ComplexArray<T>, startIndex: Index, endIndex: Index, step: Int) {
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
            precondition(0 <= index && index < count)
            return base[baseStartIndex + index * step]
        }
        set {
            precondition(0 <= index && index < count)
            base[baseStartIndex + index * step] = newValue
        }
    }

    public subscript(indices: [Int]) -> Element {
        get {
            assert(indices.count == 1)
            return self[indices[0]]
        }
        set {
            assert(indices.count == 1)
            self[indices[0]] = newValue
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

    // MARK: - Equatable

    public static func == (lhs: ComplexArraySlice, rhs: ComplexArraySlice) -> Bool {
        return lhs.count == rhs.count && lhs.elementsEqual(rhs)
    }

    public static func == (lhs: ComplexArraySlice, rhs: ComplexArray<T>) -> Bool {
        return lhs.count == rhs.count && lhs.elementsEqual(rhs)
    }
}
