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

public enum QuadraticArrangement {
    /// Consecutive elements in a rows are contiguous in memory
    case rowMajor

    /// Consecutive elements in a column are contiguous in memory
    case columnMajor
}

public protocol QuadraticType: TensorType {

    /// The arrangement of rows and columns
    var arrangement: QuadraticArrangement { get }

    /// The number of rows
    var rows: Int { get }

    /// The number of columns
    var columns: Int { get }

    /// The step size between major-axis elements
    var stride: Int { get }

    /// The step of the base elements
    var step: Int { get }
}

public extension QuadraticType {
    /// The number of valid element in the memory block, taking into account the step size.
    public var count: Int {
        return rows * columns
    }

    public var dimensions: [Int] {
        if arrangement == .rowMajor {
            return [rows, columns]
        } else {
            return [columns, rows]
        }
    }
}

public protocol MutableQuadraticType: QuadraticType, MutableTensorType {
}
