// Copyright (c) 2014–2015 Mattt Thompson (http://mattt.me)
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

// MARK: - Double

/// Hyperbolic Sine
public func sinh<C: LinearType>(_ x: C) -> ValueArray<Double> where C.Element == Double {
    precondition(x.step == 1, "sinh doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvsinh(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Hyperbolic Cosine
public func cosh<C: LinearType>(_ x: C) -> ValueArray<Double> where C.Element == Double {
    precondition(x.step == 1, "cosh doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvcosh(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Hyperbolic Tangent
public func tanh<C: LinearType>(_ x: C) -> ValueArray<Double> where C.Element == Double {
    precondition(x.step == 1, "tanh doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvtanh(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Inverse Hyperbolic Sine
public func asinh<C: LinearType>(_ x: C) -> ValueArray<Double> where C.Element == Double {
    precondition(x.step == 1, "asinh doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvasinh(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Inverse Hyperbolic Cosine
public func acosh<C: LinearType>(_ x: C) -> ValueArray<Double> where C.Element == Double {
    precondition(x.step == 1, "acosh doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvacosh(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Inverse Hyperbolic Tangent
public func atanh<C: LinearType>(_ x: C) -> ValueArray<Double> where C.Element == Double {
    precondition(x.step == 1, "atanh doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvatanh(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

// MARK: - Float

/// Hyperbolic Sine
public func sinh<C: LinearType>(_ x: C) -> ValueArray<Float> where C.Element == Float {
    precondition(x.step == 1, "sinh doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvsinhf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Hyperbolic Cosine
public func cosh<C: LinearType>(_ x: C) -> ValueArray<Float> where C.Element == Float {
    precondition(x.step == 1, "cosh doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvcoshf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Hyperbolic Tangent
public func tanh<C: LinearType>(_ x: C) -> ValueArray<Float> where C.Element == Float {
    precondition(x.step == 1, "tanh doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvtanhf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Inverse Hyperbolic Sine
public func asinh<C: LinearType>(_ x: C) -> ValueArray<Float> where C.Element == Float {
    precondition(x.step == 1, "asinh doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvasinhf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Inverse Hyperbolic Cosine
public func acosh<C: LinearType>(_ x: C) -> ValueArray<Float> where C.Element == Float {
    precondition(x.step == 1, "acosh doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvacoshf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Inverse Hyperbolic Tangent
public func atanh<C: LinearType>(_ x: C) -> ValueArray<Float> where C.Element == Float {
    precondition(x.step == 1, "atanh doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvatanhf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}
