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

/// Sine-Cosine
public func sincos<M: LinearType>(_ x: M) -> (sin: ValueArray<Double>, cos: ValueArray<Double>) where M.Element == Double {
    precondition(x.step == 1, "sincos doesn't support step values other than 1")

    let sin = ValueArray<Double>(count: x.count)
    let cos = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvsincos(sin.mutablePointer + sin.startIndex, cos.mutablePointer + cos.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return (sin, cos)
}

/// Sine
public func sin<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "sin doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvsin(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Cosine
public func cos<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "cos doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvcos(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Tangent
public func tan<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "tan doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvtan(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Arcsine
public func asin<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "asin doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvasin(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Arccosine
public func acos<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "acos doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvacos(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Arctangent
public func atan<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "atan doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvatan(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

// MARK: -

/// Radians to Degrees
func rad2deg<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "rad2deg doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    let divisor = ValueArray(count: x.count, repeatedValue: Double.pi / 180.0)
    withPointer(x) { xp in
        vvdiv(results.mutablePointer + results.startIndex, xp + x.startIndex, divisor.pointer, [Int32(x.count)])
    }

    return results
}

/// Degrees to Radians
func deg2rad<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "deg2rad doesn't support step values other than 1")

    let results = ValueArray<Double>(count: x.count)
    let divisor = ValueArray(count: x.count, repeatedValue: 180.0 / Double.pi)
    withPointer(x) { xp in
        vvdiv(results.mutablePointer + results.startIndex, xp + x.startIndex, divisor.pointer, [Int32(x.count)])
    }

    return results
}

// MARK: - Float

/// Sine-Cosine
public func sincos<M: LinearType>(_ x: M) -> (sin: ValueArray<Float>, cos: ValueArray<Float>) where M.Element == Float {
    precondition(x.step == 1, "sincos doesn't support step values other than 1")

    let sin = ValueArray<Float>(count: x.count)
    let cos = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvsincosf(sin.mutablePointer + sin.startIndex, cos.mutablePointer + cos.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return (sin, cos)
}

/// Sine
public func sin<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "sin doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvsinf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Cosine
public func cos<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "cos doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvcosf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Tangent
public func tan<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "tan doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvtanf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Arcsine
public func asin<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "asin doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvasinf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Arccosine
public func acos<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "acos doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvacosf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

/// Arctangent
public func atan<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "atan doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvatanf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }

    return results
}

// MARK: -

/// Radians to Degrees
func rad2deg<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "rad2deg doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    let divisor = ValueArray(count: x.count, repeatedValue: Float.pi / 180.0)
    withPointer(x) { xp in
        vvdivf(results.mutablePointer + results.startIndex, xp + x.startIndex, divisor.pointer, [Int32(x.count)])
    }

    return results
}

/// Degrees to Radians
func deg2rad<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "deg2rad doesn't support step values other than 1")

    let results = ValueArray<Float>(count: x.count)
    let divisor = ValueArray(count: x.count, repeatedValue: 180.0 / Float.pi)
    withPointer(x) { xp in
        vvdivf(results.mutablePointer + results.startIndex, xp + x.startIndex, divisor.pointer, [Int32(x.count)])
    }

    return results
}
