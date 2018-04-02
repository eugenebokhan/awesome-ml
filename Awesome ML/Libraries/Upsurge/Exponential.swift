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

/// Exponentiation
public func exp<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "exp doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvexp(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Square Exponentiation
public func exp2<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "exp2 doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvexp2(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Natural Logarithm
public func log<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "log doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvlog(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Base-2 Logarithm
public func log2<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "log2 doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvlog2(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Base-10 Logarithm
public func log10<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "log10 doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvlog10(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Logarithmic Exponentiation
public func logb<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "logb doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvlogb(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

// MARK: - Float

/// Exponentiation
public func exp<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "exp doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvexpf(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Square Exponentiation
public func exp2<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "exp2 doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvexp2f(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Natural Logarithm
public func log<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "log doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvlogf(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Base-2 Logarithm
public func log2<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "log2 doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvlog2f(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Base-10 Logarithm
public func log10<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "log10 doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvlog10f(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Logarithmic Exponentiation
public func logb<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "logb doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvlogbf(results.mutablePointer, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}
