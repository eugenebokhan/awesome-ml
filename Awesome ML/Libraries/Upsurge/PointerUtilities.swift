// Copyright © 2016 Venture Media Labs.
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

import Foundation

// MARK: One parameter

/// Call `body(pointer)` with the pointer for the type
public func withPointer<T: TensorType, R>(_ t: T, body: (UnsafePointer<T.Element>) throws -> R) rethrows -> R {
    return try t.withUnsafePointer(body)
}

/// Call `body(pointer)` with the mutable pointer for the type
public func withPointer<T: MutableTensorType, R>(_ t: inout T, body: (UnsafeMutablePointer<T.Element>) throws -> R) rethrows -> R {
    return try t.withUnsafeMutablePointer(body)
}

// MARK: Two parameters

/// Invokes the given closure with pointers to the given arguments (2 parameter version).
///
/// - See: `withUnsafePointer(to:body:)`
@discardableResult
public func withUnsafePointersTo<A, B, Result>(_ a: inout A, _ b: inout B, body: (UnsafePointer<A>, UnsafePointer<B>) throws -> Result) rethrows -> Result {
    return try withUnsafePointer(to: &a) { (a: UnsafePointer<A>) throws -> Result in
        return try withUnsafePointer(to: &b) { (b: UnsafePointer<B>) throws -> Result in
            return try body(a, b)
        }
    }
}

/// Invokes the given closure with mutable pointers to the given arguments (2 parameter version).
///
/// - See: `withUnsafeMutablePointer(to:body:)`
@discardableResult
public func withUnsafeMutablePointersTo<A, B, Result>(_ a: inout A, _ b: inout B, body: (UnsafeMutablePointer<A>, UnsafeMutablePointer<B>) throws -> Result) rethrows -> Result {
    return try withUnsafeMutablePointer(to: &a) { (a: UnsafeMutablePointer<A>) throws -> Result in
        return try withUnsafeMutablePointer(to: &b) { (b: UnsafeMutablePointer<B>) throws -> Result in
            return try body(a, b)
        }
    }
}
/// Call `body(p1, p2)` with the pointers for the two types
public func withPointers<T1: TensorType, T2: TensorType, R>(_ t1: T1, _ t2: T2, body: (UnsafePointer<T1.Element>, UnsafePointer<T2.Element>) throws -> R) rethrows -> R where T1.Element == T2.Element {
    return try t1.withUnsafeBufferPointer { p1 in
        try t2.withUnsafeBufferPointer { p2 in
            try body(p1.baseAddress!, p2.baseAddress!)
        }
    }
}

/// Call `body(p1, p2)` with the pointers for the two types
public func withPointers<T1: TensorType, T2: MutableTensorType, R>(_ t1: T1, _ t2: inout T2, body: (UnsafePointer<T1.Element>, UnsafeMutablePointer<T2.Element>) throws -> R) rethrows -> R where T1.Element == T2.Element {
    return try t1.withUnsafeBufferPointer { p1 in
        try t2.withUnsafeMutableBufferPointer { p2 in
            try body(p1.baseAddress!, p2.baseAddress!)
        }
    }
}

/// Call `body(p1, p2)` with the pointers for the two types
public func withPointers<T1: MutableTensorType, T2: TensorType, R>(_ t1: inout T1, _ t2: T2, body: (UnsafeMutablePointer<T1.Element>, UnsafePointer<T2.Element>) throws -> R) rethrows -> R where T1.Element == T2.Element {
    return try t1.withUnsafeMutableBufferPointer { p1 in
        try t2.withUnsafeBufferPointer { p2 in
            try body(p1.baseAddress!, p2.baseAddress!)
        }
    }
}

/// Call `body(p1, p2)` with the pointers for the two types
public func withPointers<T1: MutableTensorType, T2: MutableTensorType, R>(_ t1: inout T1, _ t2: inout T2, body: (UnsafeMutablePointer<T1.Element>, UnsafeMutablePointer<T2.Element>) throws -> R) rethrows -> R where T1.Element == T2.Element {
    return try t1.withUnsafeMutableBufferPointer { p1 in
        try t2.withUnsafeMutableBufferPointer { p2 in
            try body(p1.baseAddress!, p2.baseAddress!)
        }
    }
}

// MARK: Three parameters

/// Call `body(p1, p2, p3)` with the pointers for the three types
public func withPointers<T1: TensorType, T2: TensorType, T3: MutableTensorType, R>(_ t1: T1, _ t2: T2, _ t3: inout T3, body: (UnsafePointer<T1.Element>, UnsafePointer<T2.Element>, UnsafeMutablePointer<T3.Element>) throws -> R) rethrows -> R where T1.Element == T2.Element, T2.Element == T3.Element {
    return try t1.withUnsafeBufferPointer { p1 in
        try t2.withUnsafeBufferPointer { p2 in
            try t3.withUnsafeMutableBufferPointer { p3 in
                try body(p1.baseAddress!, p2.baseAddress!, p3.baseAddress!)
            }
        }
    }
}

/// Invokes the given closure with pointers to the given arguments (3 parameter version).
///
/// - See: `withUnsafePointer(to:body:)`
@discardableResult
public func withUnsafePointersTo<A, B, C, Result>(_ a: inout A, _ b: inout B, _ c: inout C, body: (UnsafePointer<A>, UnsafePointer<B>, UnsafePointer<C>) throws -> Result) rethrows -> Result {
    return try withUnsafePointer(to: &a) { (a: UnsafePointer<A>) throws -> Result in
        return try withUnsafePointer(to: &b) { (b: UnsafePointer<B>) throws -> Result in
            return try withUnsafePointer(to: &c) { (c: UnsafePointer<C>) throws -> Result in
                return try body(a, b, c)
            }
        }
    }
}

/// Invokes the given closure with mutable pointers to the given arguments (3 parameter version).
///
/// - See: `withUnsafeMutablePointer(to:body:)`
@discardableResult
public func withUnsafeMutablePointersTo<A, B, C, Result>(_ a: inout A, _ b: inout B, _ c: inout C, body: (UnsafeMutablePointer<A>, UnsafeMutablePointer<B>, UnsafeMutablePointer<C>) throws -> Result) rethrows -> Result {
    return try withUnsafeMutablePointer(to: &a) { (a: UnsafeMutablePointer<A>) throws -> Result in
        return try withUnsafeMutablePointer(to: &b) { (b: UnsafeMutablePointer<B>) throws -> Result in
            return try withUnsafeMutablePointer(to: &c) { (c: UnsafeMutablePointer<C>) throws -> Result in
                return try body(a, b, c)
            }
        }
    }
}
