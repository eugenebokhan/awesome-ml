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

/// Compute the absolute value for each element in `x`, return a new `ValueArray` with the results
public func abs<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vDSP_vabsD(p + x.startIndex, x.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Compute the absolute value for each element in `x`, store the results in `results`
public func abs<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    let step = results.step
    withPointers(x, &results) { xp, rp in
        vDSP_vabsD(xp + x.startIndex, x.step, rp + startIndex, step, vDSP_Length(x.count))
    }
}

/// Compute the ceiling for each element in `x`, return a new `ValueArray` with the results
public func ceil<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "ceil doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvceil(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Compute the ceiling for each element in `x`, store the results in `results`
public func ceil<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.step == 1, "ceil doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvceil(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Clip every element in `x`, return a new `ValueArray` with the results
public func clip<M: LinearType>(_ x: M, low: Double, high: Double) -> ValueArray<Double> where M.Element == Double {
    var results = ValueArray<Double>(count: x.count), y = low, z = high
    withPointer(x) { p in
        vDSP_vclipD(p + x.startIndex, x.step, &y, &z, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Clip every element in `x`, store the results in `results`
public func clip<MI: LinearType, MO: MutableLinearType>(_ x: MI, low: Double, high: Double, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.count == results.count)
    var l = low, h = high
    let startIndex = results.startIndex
    let step = results.step
    withPointers(x, &results) { xp, yp in
        vDSP_vclipD(xp + x.startIndex, x.step, &l, &h, yp + startIndex, step, vDSP_Length(x.count))
    }
}

// Copy Sign
public func copysign<M: LinearType>(_ sign: M, magnitude: M) -> ValueArray<Double> where M.Element == Double {
    precondition(sign.step == 1 && magnitude.step == 1, "copysign doesn't support step values other than 1")
    let results = ValueArray<Double>(count: sign.count)
    withPointers(sign, magnitude) { signPointer, magnitudePointer in
        vvcopysign(results.mutablePointer + results.startIndex, magnitudePointer + magnitude.startIndex, signPointer + sign.startIndex, [Int32(sign.count)])
    }
    return results
}

/// Compute the floor for each element in `x`, return a new `ValueArray` with the results
public func floor<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "floor doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvfloor(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Compute the floor for each element in `x`, store the results in `results`
public func floor<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.step == 1, "floor doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvfloor(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Compute the negative of each element in `x`, return a new `ValueArray` with the results
public func neg<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vDSP_vnegD(p + x.startIndex, x.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Compute the negative of each element in `x`, store the results in `results`
public func neg<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    let step = results.step
    withPointers(x, &results) { xp, rp in
        vDSP_vnegD(xp + x.startIndex, x.step, rp + startIndex, step, vDSP_Length(x.count))
    }
}

/// Compute the reciprocal of each element in `x`, return a new `ValueArray` with the results
public func rec<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "rec doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvrec(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Compute the reciprocal of each element in `x`, store the results in `results`
public func rec<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.step == 1, "rec doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvrec(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Round each element in `x`, return a new `ValueArray` with the results
public func round<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "round doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvnint(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Round each element in `x`, store the results in `results`
public func round<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.step == 1, "round doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvnint(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Threshold each element in `x`, return a new `ValueArray` with the results
public func threshold<M: LinearType>(_ x: M, low: Double) -> ValueArray<Double> where M.Element == Double {
    var results = ValueArray<Double>(count: x.count), y = low
    withPointer(x) { p in
        vDSP_vthrD(p + x.startIndex, x.step, &y, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Threshold each element in `x`, store the results in `results`
public func threshold<MI: LinearType, MO: MutableLinearType>(_ x: MI, low: Double, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.count == results.count)
    var l = low
    let startIndex = results.startIndex
    let step = results.step
    withPointers(x, &results) { xp, rp in
        vDSP_vthrD(xp + x.startIndex, x.step, &l, rp + startIndex, step, vDSP_Length(x.count))
    }
}

/// Truncate each element in `x`, return a new `ValueArray` with the results
public func trunc<M: LinearType>(_ x: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "trunc doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvint(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Truncate each element in `x`, store the results in `results`
public func trunc<MI: LinearType, MO: MutableLinearType>(_ x: MI, low: Double, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.step == 1, "trunc doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvint(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Compute `x^y` for each element of `x` and `y`, return a new `ValueArray` with the results
public func pow<M: LinearType>(_ x: M, _ y: M) -> ValueArray<Double> where M.Element == Double {
    precondition(x.step == 1, "pow doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointers(x, y) { xp, yp in
        vvpow(results.mutablePointer + results.startIndex, xp + x.startIndex, yp + y.startIndex, [Int32(x.count)])
    }
    return results
}

/// Compute `x^y` for each element of `x` and `y`, store the results in `results`
public func pow<MI: LinearType, MO: MutableLinearType>(_ x: MI, _ y: MI, results: inout MO) where MI.Element == Double, MO.Element == Double {
    precondition(x.step == 1, "pow doesn't support step values other than 1")
    let startIndex = results.startIndex
    withPointers(x, y, &results) { xp, yp, rp in
        vvpow(rp + startIndex, xp + x.startIndex, yp + y.startIndex, [Int32(x.count)])
    }
}

// MARK: - Float

/// Compute the absolute value for each element in `x`, return a new `ValueArray` with the results
public func abs<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vDSP_vabs(p + x.startIndex, x.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Compute the absolute value for each element in `x`, store the results in `results`
public func abs<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    let step = results.step
    withPointers(x, &results) { xp, rp in
        vDSP_vabs(xp + x.startIndex, x.step, rp + startIndex, step, vDSP_Length(x.count))
    }
}

/// Compute the ceiling for each element in `x`, return a new `ValueArray` with the results
public func ceil<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "ceil doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    let startIndex = results.startIndex
    withPointer(x) { p in
        vvceilf(results.mutablePointer + startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Compute the ceiling for each element in `x`, store the results in `results`
public func ceil<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.step == 1, "ceil doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvceilf(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Clip every element in `x`, return a new `ValueArray` with the results
public func clip<M: LinearType>(_ x: M, low: Float, high: Float) -> ValueArray<Float> where M.Element == Float {
    var results = ValueArray<Float>(count: x.count), y = low, z = high
    withPointer(x) { p in
        vDSP_vclip(p + x.startIndex, x.step, &y, &z, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Clip every element in `x`, store the results in `results`
public func clip<MI: LinearType, MO: MutableLinearType>(_ x: MI, low: Float, high: Float, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.count == results.count)
    var l = low, h = high
    let startIndex = results.startIndex
    let step = results.step
    withPointers(x, &results) { xp, yp in
        vDSP_vclip(xp + x.startIndex, x.step, &l, &h, yp + startIndex, step, vDSP_Length(x.count))
    }
}

// Copy Sign
public func copysign<M: LinearType>(_ sign: M, magnitude: M) -> ValueArray<Float> where M.Element == Float {
    precondition(sign.step == 1 && magnitude.step == 1, "copysign doesn't support step values other than 1")
    let results = ValueArray<Float>(count: sign.count)
    withPointers(sign, magnitude) { signPointer, magnitudePointer in
        vvcopysignf(results.mutablePointer + results.startIndex, magnitudePointer + magnitude.startIndex, signPointer + sign.startIndex, [Int32(sign.count)])
    }
    return results
}

/// Compute the floor for each element in `x`, return a new `ValueArray` with the results
public func floor<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "floor doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvfloorf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Compute the floor for each element in `x`, store the results in `results`
public func floor<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.step == 1, "floor doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvfloorf(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Compute the negative of each element in `x`, return a new `ValueArray` with the results
public func neg<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vDSP_vneg(p + x.startIndex, x.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Compute the negative of each element in `x`, store the results in `results`
public func neg<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    let step = results.step
    withPointers(x, &results) { xp, rp in
        vDSP_vneg(xp + x.startIndex, x.step, rp + startIndex, step, vDSP_Length(x.count))
    }
}

/// Compute the reciprocal of each element in `x`, return a new `ValueArray` with the results
public func rec<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "rec doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvrecf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Compute the reciprocal of each element in `x`, store the results in `results`
public func rec<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.step == 1, "rec doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvrecf(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Round each element in `x`, return a new `ValueArray` with the results
public func round<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "round doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvnintf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Round each element in `x`, store the results in `results`
public func round<MI: LinearType, MO: MutableLinearType>(_ x: MI, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.step == 1, "round doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvnintf(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Threshold each element in `x`, return a new `ValueArray` with the results
public func threshold<M: LinearType>(_ x: M, low: Float) -> ValueArray<Float> where M.Element == Float {
    var results = ValueArray<Float>(count: x.count), y = low
    withPointer(x) { p in
        vDSP_vthr(p + x.startIndex, x.step, &y, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Threshold each element in `x`, store the results in `results`
public func threshold<MI: LinearType, MO: MutableLinearType>(_ x: MI, low: Float, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.count == results.count)
    var l = low
    let startIndex = results.startIndex
    let step = results.step
    withPointers(x, &results) { xp, rp in
        vDSP_vthr(xp + x.startIndex, x.step, &l, rp + startIndex, step, vDSP_Length(x.count))
    }
}

/// Truncate each element in `x`, return a new `ValueArray` with the results
public func trunc<M: LinearType>(_ x: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "trunc doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvintf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Truncate each element in `x`, store the results in `results`
public func trunc<MI: LinearType, MO: MutableLinearType>(_ x: MI, low: Float, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.step == 1, "trunc doesn't support step values other than 1")
    precondition(x.count == results.count)
    let startIndex = results.startIndex
    withPointers(x, &results) { xp, rp in
        vvintf(rp + startIndex, xp + x.startIndex, [Int32(x.count)])
    }
}

/// Compute `x^y` for each element of `x` and `y`, return a new `ValueArray` with the results
public func pow<M: LinearType>(_ x: M, _ y: M) -> ValueArray<Float> where M.Element == Float {
    precondition(x.step == 1, "pow doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointers(x, y) { xp, yp in
        vvpowf(results.mutablePointer + results.startIndex, xp + x.startIndex, yp + y.startIndex, [Int32(x.count)])
    }
    return results
}

/// Compute `x^y` for each element of `x` and `y`, store the results in `results`
public func pow<MI: LinearType, MO: MutableLinearType>(_ x: MI, _ y: MI, results: inout MO) where MI.Element == Float, MO.Element == Float {
    precondition(x.step == 1, "pow doesn't support step values other than 1")
    let startIndex = results.startIndex
    withPointers(x, y, &results) { xp, yp, rp in
        vvpowf(rp + startIndex, xp + x.startIndex, yp + y.startIndex, [Int32(x.count)])
    }
}
