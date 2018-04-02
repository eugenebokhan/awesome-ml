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

public protocol TensorType {
    associatedtype Element
    associatedtype Slice

    /// A description of the dimensions over which the TensorType spans
    var span: Span { get }
    var count: Int { get }

    subscript(intervals: [IntervalType]) -> Slice { get }
    subscript(intervals: [Int]) -> Element { get }

    /// Call `body(pointer)` with the buffer pointer to the beginning of the memory block
    func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R

    /// Call `body(pointer)` with the pointer to the beginning of the memory block
    func withUnsafePointer<R>(_ body: (UnsafePointer<Element>) throws -> R) rethrows -> R
}

public extension TensorType {
    /// The size of each dimension
    public var dimensions: [Int] {
        return span.dimensions
    }

    /// The number of dimensions
    public var rank: Int {
        return span.rank
    }

    /// Convert a high-dimensional index into an integer index for a LinearType
    public func linearIndex(_ indices: [Int]) -> Int {
        precondition(indexIsValid(indices))
        var index = indices[0]
        for (i, dim) in span.dimensions[1..<rank].enumerated() {
            index = (dim * index) + indices[i+1]
        }
        return index
    }

    /// Check that an index falls within the span
    public func indexIsValid(_ indices: [Int]) -> Bool {
        return indices.count == rank && indices.enumerated().all { (i, index) in
            self.span[i].contains(index)
        }
    }
}

public protocol MutableTensorType: TensorType {
    subscript(intervals: [IntervalType]) -> Slice { get set }
    subscript(intervals: [Int]) -> Element { get set }

    /// Call `body(pointer)` with the mutable buffer pointer to the beginning of the memory block
    mutating func withUnsafeMutableBufferPointer<R>(_ body: (UnsafeMutableBufferPointer<Element>) throws -> R) rethrows -> R

    /// Call `body(pointer)` with the mutable pointer to the beginning of the memory block
    mutating func withUnsafeMutablePointer<R>(_ body: (UnsafeMutablePointer<Element>) throws -> R) rethrows -> R
}

public extension MutableTensorType {
    /// Assign all values of a TensorType to this tensor.
    ///
    /// - precondition: The available space on `self` is greater than or equal to the number of elements on `lhs`
    mutating func assignFrom<T: TensorType>(_ rhs: T) where T.Element == Element {
        let count = self.count
        precondition(rhs.count <= count)
        withPointers(&self, rhs) { lhsp, rhsp in
            lhsp.assign(from: UnsafeMutablePointer(mutating: rhsp), count: count)
        }
    }
}
