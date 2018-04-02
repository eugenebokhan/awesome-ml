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

/// A slice of reals from a ComplexArray.
public struct ComplexArrayRealSlice<T: Real>: MutableLinearType {
    public typealias Index = Int
    public typealias Element = T
    public typealias Slice = ComplexArrayRealSlice

    public let base: ComplexArray<T>
    public let baseStartIndex: Index
    public let baseEndIndex: Index
    public let step: Int

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
        return try withUnsafePointer { pointer in
            return try body(UnsafeBufferPointer(start: pointer, count: count))
        }
    }

    public func withUnsafePointer<R>(_ body: (UnsafePointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafePointer { pointer in
            return try pointer.withMemoryRebound(to: Element.self, capacity: base.capacity) { pointer in
                try body(pointer + baseStartIndex)
            }
        }
    }

    public func withUnsafeMutableBufferPointer<R>(_ body: (UnsafeMutableBufferPointer<Element>) throws -> R) rethrows -> R {
        return try withUnsafeMutablePointer { pointer in
            return try body(UnsafeMutableBufferPointer(start: pointer, count: count))
        }
    }

    public func withUnsafeMutablePointer<R>(_ body: (UnsafeMutablePointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafeMutablePointer { pointer in
            return try pointer.withMemoryRebound(to: Element.self, capacity: base.capacity) { pointer in
                try body(pointer + baseStartIndex)
            }
        }
    }

    init(base: ComplexArray<T>, startIndex: Int, endIndex: Int, step: Int) {
        assert(2 * base.startIndex <= startIndex && endIndex <= 2 * base.endIndex)
        self.base = base
        self.baseStartIndex = startIndex
        self.baseEndIndex = endIndex
        self.step = step
    }

    public func assign<C: LinearType>(_ elements: C) where C.Element == Element {
        withUnsafeMutablePointer { pointer in
            for (i, value) in zip(stride(from: baseStartIndex, to: baseEndIndex, by: step), elements) {
                pointer[i] = value
            }
        }
    }

    public subscript(index: Int) -> Element {
        get {
            let baseIndex = startIndex + index
            precondition(0 <= baseIndex && baseIndex < 2 * base.count)
            return withUnsafePointer { pointer in
                pointer[baseIndex]
            }
        }
        set {
            let baseIndex = startIndex + index
            precondition(0 <= baseIndex && baseIndex < base.count)
            withUnsafeMutablePointer { pointer in
                pointer[baseIndex] = newValue
            }
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
            assert(intervals.count == 1)
            let start = intervals[0].start ?? startIndex
            let end = intervals[0].end ?? endIndex
            return Slice(base: base, startIndex: start, endIndex: end, step: step)
        }
        set {
            assert(intervals.count == 1)
            let start = intervals[0].start ?? startIndex
            let end = intervals[0].end ?? endIndex
            assert(startIndex <= start && end <= endIndex)
            for i in start..<end {
                self[i] = newValue[newValue.startIndex + i - start]
            }
        }
    }

    public func index(after i: Index) -> Index {
        return i + step
    }

    static public func == (lhs: ComplexArrayRealSlice, rhs: ComplexArrayRealSlice) -> Bool {
        return lhs.count == rhs.count && lhs.elementsEqual(rhs)
    }
}
