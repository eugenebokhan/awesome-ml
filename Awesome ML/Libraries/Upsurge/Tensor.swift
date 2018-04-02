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

import Accelerate

/// A `Tensor` is a multi-dimensional collection of values.
open class Tensor<Element: Value>: MutableTensorType, Equatable {
    public typealias Index = [Int]
    public typealias Slice = TensorSlice<Element>

    open var elements: ValueArray<Element>

    open func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
        return try elements.withUnsafeBufferPointer(body)
    }

    open func withUnsafePointer<R>(_ body: (UnsafePointer<Element>) throws -> R) rethrows -> R {
        return try elements.withUnsafePointer(body)
    }

    open func withUnsafeMutableBufferPointer<R>(_ body: (UnsafeMutableBufferPointer<Element>) throws -> R) rethrows -> R {
        return try elements.withUnsafeMutableBufferPointer(body)
    }

    open func withUnsafeMutablePointer<R>(_ body: (UnsafeMutablePointer<Element>) throws -> R) rethrows -> R {
        return try elements.withUnsafeMutablePointer(body)
    }

    open var span: Span

    open var count: Int {
        return span.count
    }

    public init<M: LinearType>(dimensions: [Int], elements: M) where M.Element == Element {
        assert(dimensions.reduce(1, *) == elements.count)
        self.span = Span(zeroTo: dimensions)
        self.elements = ValueArray(elements)
    }

    public init(_ tensor: Tensor<Element>) {
        self.span = tensor.span
        self.elements = ValueArray<Element>(tensor.elements)
    }

    public convenience init(_ tensorSlice: TensorSlice<Element>) {
        self.init(dimensions: tensorSlice.dimensions)
        for index in Span(zeroTo: dimensions) {
            self[index] = tensorSlice[index]
        }
    }

    public init(_ matrix: Matrix<Element>) {
        self.span = matrix.span
        self.elements = ValueArray<Element>(matrix.elements)
    }

    public init(dimensions: [Int]) {
        self.span = Span(zeroTo: dimensions)
        self.elements = ValueArray(count: dimensions.reduce(1, *))
    }

    public init(dimensions: [Int], repeatedValue: Element) {
        self.span = Span(zeroTo: dimensions)
        self.elements = ValueArray(count: dimensions.reduce(1, *), repeatedValue: repeatedValue)
    }

    public init(dimensions: [Int], initializer: () -> Element) {
        self.span = Span(zeroTo: dimensions)
        self.elements = ValueArray(count: dimensions.reduce(1, *), initializer: initializer)
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
            var index = [Int](repeating: 0, count: dimensions.count)
            let indexReplacementRage = dimensions.count - indices.count ... dimensions.count - 1
            index.replaceSubrange(indexReplacementRage, with: indices)
            assert(indexIsValid(index))
            let elementsIndex = linearIndex(index)
            return elements[elementsIndex]
        }
        set {
            var index = [Int](repeating: 0, count: dimensions.count)
            let indexReplacementRage = dimensions.count - indices.count ... dimensions.count - 1
            index.replaceSubrange(indexReplacementRage, with: indices)
            assert(indexIsValid(index))
            let elementsIndex = linearIndex(index)
            elements[elementsIndex] = newValue
        }
    }

    open subscript(slice: IntervalType...) -> TensorSlice<Element> {
        get {
            return self[slice]
        }
        set {
            self[slice] = newValue
        }
    }

    open subscript(slice: [IntervalType]) -> TensorSlice<Element> {
        get {
            let subSpan = Span(base: span, intervals: slice)
            return self[subSpan]
        }
        set {
            let subSpan = Span(base: span, intervals: slice)
            self[subSpan] = newValue
        }
    }

    subscript(span: Span) -> TensorSlice<Element> {
        get {
            assert(spanIsValid(span))
            return TensorSlice(base: self, span: span)
        }
        set {
            assert(spanIsValid(span))
            assert(span ≅ newValue.span)
            let tensorSlice = TensorSlice(base: self, span: span)
            tensorSlice[tensorSlice.span] = newValue
        }
    }

    open func reshape(_ span: Span) {
        precondition(span.count == self.span.count)
        self.span = span
    }

    open func copy() -> Tensor {
        return Tensor(self)
    }

    func spanIsValid(_ subSpan: Span) -> Bool {
        let span = Span(zeroTo: dimensions)
        return span.contains(subSpan)
    }
}

// MARK: - Matrix Extraction

extension Tensor {
    /**
     Extract a matrix from the tensor.
     
     - Precondition: All but the last two intervals must be a specific index, not a range. The last interval must either span the full dimension, or the second-last interval count must be 1.
     */
    func asMatrix(_ span: Span) -> TwoDimensionalTensorSlice<Element> {
        return TwoDimensionalTensorSlice(base: self, span: span)
    }

    public func asMatrix(_ intervals: IntervalType...) -> TwoDimensionalTensorSlice<Element> {
        let baseSpan = Span(zeroTo: dimensions)
        let matrixSpan = Span(base: baseSpan, intervals: intervals)
        return asMatrix(matrixSpan)
    }

}

// MARK: -

public func swap<T>(_ lhs: Tensor<T>, rhs: Tensor<T>) {
    swap(&lhs.span, &rhs.span)
    swap(&lhs.elements, &rhs.elements)
}

// MARK: - Equatable

extension Tensor {
    public static func == (lhs: Tensor, rhs: Tensor) -> Bool {
        return lhs.elements == rhs.elements
    }

    public static func == (lhs: Tensor, rhs: TensorSlice<Element>) -> Bool {
        assert(lhs.span ≅ rhs.span)
        return zip(lhs.span, rhs.span).all { lhs[$0] == rhs[$1] }
    }

    public static func == (lhs: Tensor, rhs: Matrix<Element>) -> Bool {
        return lhs.elements == rhs.elements
    }

    public static func == (lhs: Tensor, rhs: MatrixSlice<Element>) -> Bool {
        assert(lhs.span ≅ rhs.span)
        return zip(lhs.span, rhs.span).all { lhs[$0] == rhs[$1] }
    }

    public static func == (lhs: Tensor, rhs: TwoDimensionalTensorSlice<Element>) -> Bool {
        assert(lhs.span ≅ rhs.span)
        return zip(lhs.span, rhs.span).all { lhs[$0] == rhs[$1] }
    }
}
