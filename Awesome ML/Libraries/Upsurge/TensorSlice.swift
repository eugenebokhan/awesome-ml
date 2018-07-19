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

open class TensorSlice<Element: Value>: MutableTensorType, Equatable {
    public typealias Index = [Int]
    public typealias Slice = TensorSlice<Element>

    public let base: Tensor<Element>

    public let span: Span

    open var count: Int {
        return span.count
    }

    open func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafeBufferPointer(body)
    }

    open func withUnsafePointer<R>(_ body: (UnsafePointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafePointer(body)
    }

    open func withUnsafeMutableBufferPointer<R>(_ body: (UnsafeMutableBufferPointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafeMutableBufferPointer(body)
    }

    open func withUnsafeMutablePointer<R>(_ body: (UnsafeMutablePointer<Element>) throws -> R) rethrows -> R {
        return try base.withUnsafeMutablePointer(body)
    }

    init(base: Tensor<Element>, span: Span) {
        assert(span.rank == base.rank)
        self.base = base
        self.span = span
    }

    open subscript(indices: Int...) -> Element {
        get {
            return self[indices]
        }
        set {
            self[indices] = newValue
        }
    }

    open subscript(indices: Index) -> Element {
        get {
            var index = span.startIndex
            let indexReplacementRage: CountableClosedRange<Int> = span.startIndex.count - indices.count ... span.startIndex.count - 1
            index.replaceSubrange(indexReplacementRage, with: indices)
            assert(indexIsValid(index))
            return base[index]
        }
        set {
            var index = span.startIndex
            let indexReplacementRage: CountableClosedRange<Int> = span.startIndex.count - indices.count ... span.startIndex.count - 1
            index.replaceSubrange(indexReplacementRage, with: indices)
            assert(indexIsValid(index))
            base[index] = newValue
        }
    }

    open subscript(slice: [IntervalType]) -> Slice {
        get {
            let span = Span(base: self.span, intervals: slice)
            return TensorSlice(base: base, span: span)
        }
        set {
            let span = Span(base: self.span, intervals: slice)
            assert(span ≅ newValue.span)
            for index in span {
                base[index] = newValue[index]
            }
        }
    }

    open subscript(slice: IntervalType...) -> Slice {
        get {
            return self[slice]
        }
        set {
            self[slice] = newValue
        }
    }

    subscript(span: Span) -> Slice {
        get {
            assert(span.contains(span))
            return TensorSlice(base: base, span: span)
        }
        set {
            assert(span.contains(span))
            assert(span ≅ newValue.span)
            for (lhsIndex, rhsIndex) in zip(span, newValue.span) {
                base[lhsIndex] = newValue[rhsIndex]
            }
        }
    }

    open var isContiguous: Bool {
        let onesCount: Int = (dimensions.index { $0 != 1 }) ?? rank
        let diff = (0..<rank).map { dimensions[$0] - base.dimensions[$0] }.reversed()
        let fullCount: Int
        if let index = (diff.index { $0 != 0 }), index.base < count {
            fullCount = rank - index.base
        } else {
            fullCount = rank
        }

        return rank - fullCount - onesCount <= 1
    }

    open func indexIsValid(_ indices: [Int]) -> Bool {
        assert(indices.count == dimensions.count)
        return indices.enumerated().all { (i, index) in self.span[i].contains(index) }
    }
}

// MARK: - Equatable

public func ==<L: TensorType, R: TensorType>(lhs: L, rhs: R) -> Bool where L.Element == R.Element, L.Element: Equatable {
    return lhs.span ≅ rhs.span && zip(lhs.span, rhs.span).all { lhs[$0] == rhs[$1] }
}
