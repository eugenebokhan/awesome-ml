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

open class TwoDimensionalTensorSlice<Element: Value>: MutableQuadraticType, Equatable {
    public typealias Index = [Int]
    public typealias Slice = TwoDimensionalTensorSlice<Element>

    open var arrangement: QuadraticArrangement {
        return .rowMajor
    }

    public let rows: Int
    public let columns: Int
    public let stride: Int

    let base: Tensor<Element>
    public let span: Span

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

    open var step: Int {
        return base.elements.step
    }

    init(base: Tensor<Element>, span: Span) {
        assert(span.dimensions.count == base.dimensions.count)
        self.base = base
        self.span = span

        assert(base.spanIsValid(span))
        assert(span.dimensions.reduce(0) { $1 > 1 ? $0 + 1 : $0 } <= 2)
        assert(span.dimensions.last! >= 1)

        let rowIndex: Int = span.dimensions.index { $0 > 1 } ??
                           (span.dimensions.count - 2)

        rows = span.dimensions[rowIndex]
        columns = span.dimensions.last!

        stride = span.dimensions.suffix(from: rowIndex + 1).reduce(1, *)
    }

    open subscript(row: Int, column: Int) -> Element {
        get {
            return self[[row, column]]
        }
        set {
            self[[row, column]] = newValue
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
            return self[span]
        }
        set {
            let span = Span(base: self.span, intervals: slice)
            assert(span ≅ newValue.span)
            self[span] = newValue
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
            assert(self.span.contains(span))
            return Slice(base: base, span: span)
        }
        set {
            assert(self.span.contains(span))
            assert(span ≅ newValue.span)
            for (lhsIndex, rhsIndex) in zip(span, newValue.span) {
                base[lhsIndex] = newValue[rhsIndex]
            }
        }
    }

    open var isContiguous: Bool {
        let onesCount: Int = (dimensions.index { $0 != 1 }) ?? rank

        let diff = (0..<rank).map({ dimensions[$0] - base.dimensions[$0] }).reversed()
        let fullCount: Int
        if let index = (diff.index { $0 != 0 }), index.base < count {
            fullCount = rank - index.base
        } else {
            fullCount = rank
        }

        return rank - fullCount - onesCount <= 1
    }

    open func indexIsValid(_ indices: [Int]) -> Bool {
        assert(indices.count == rank)
        return indices.enumerated().all { (i, index) in
            self.span[i].contains(index)
        }
    }
}
