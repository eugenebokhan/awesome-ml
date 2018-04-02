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

// MARK: - Double

public func +=<ML: MutableLinearType, MR: LinearType>(lhs: inout ML, rhs: MR) where ML.Element == Double, MR.Element == Double {
    assert(lhs.count >= rhs.count)
    let count = min(lhs.count, rhs.count)
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointers(rhs, &lhs) { rhsp, lhsp in
        vDSP_vaddD(lhsp + lhsStart, lhsStep, rhsp + rhs.startIndex, rhs.step, lhsp, lhsStep, vDSP_Length(count))
    }
}

public func +<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Double> where ML.Element == Double, MR.Element == Double {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Double>(count: count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_vaddD(lhsp + lhs.startIndex, lhs.step, rhsp + rhs.startIndex, rhs.step, results.mutablePointer, results.step, vDSP_Length(count))
    }
    return results
}

public func +=<ML: MutableLinearType>(lhs: inout ML, rhs: Double) where ML.Element == Double {
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointer(&lhs) { lhsp in
        var scalar = rhs
        vDSP_vsaddD(lhsp + lhsStart, lhsStep, &scalar, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func +<ML: LinearType>(lhs: ML, rhs: Double) -> ValueArray<Double> where ML.Element == Double {
    var rhs = rhs
    let results = ValueArray<Double>(count: lhs.count)
    withPointer(lhs) { lhsp in
        vDSP_vsaddD(lhsp + lhs.startIndex, lhs.step, &rhs, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func +<MR: LinearType>(lhs: Double, rhs: MR) -> ValueArray<Double> where MR.Element == Double {
    return rhs + lhs
}

public func -=<ML: MutableLinearType, MR: LinearType>(lhs: inout ML, rhs: MR) where ML.Element == Double, MR.Element == Double {
    let count = min(lhs.count, rhs.count)
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointers(rhs, &lhs) { rhsp, lhsp in
    vDSP_vsubD(rhsp + rhs.startIndex, rhs.step, lhsp + lhsStart, lhsStep, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func -<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Double> where ML.Element == Double, MR.Element == Double {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Double>(count: count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_vsubD(rhsp + rhs.startIndex, rhs.step, lhsp + lhs.startIndex, lhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(count))
    }
    return results
}

public func -=<ML: MutableLinearType>(lhs: inout ML, rhs: Double) where ML.Element == Double {
    var scalar: Double = -rhs
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointer(&lhs) { lhsp in
        vDSP_vsaddD(lhsp + lhsStart, lhsStep, &scalar, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func -<ML: LinearType>(lhs: ML, rhs: Double) -> ValueArray<Double> where ML.Element == Double {
    let results = ValueArray<Double>(count: lhs.count)
    var scalar: Double = -rhs
    withPointer(lhs) { lhsp in
        vDSP_vsaddD(lhsp + lhs.startIndex, lhs.step, &scalar, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func -<ML: LinearType>(lhs: Double, rhs: ML) -> ValueArray<Double> where ML.Element == Double {
    let results = ValueArray<Double>(count: rhs.count)
    withPointer(rhs) { rhsp in
        var scalarm: Double = -1
        var scalara: Double = lhs
        vDSP_vsmsaD(rhsp + rhs.startIndex, rhs.step, &scalarm, &scalara, results.mutablePointer + results.startIndex, results.step, vDSP_Length(rhs.count))
    }
    return results
}

public func /=<ML: MutableLinearType, MR: LinearType>(lhs: inout ML, rhs: MR) where ML.Element == Double, MR.Element == Double {
    let count = min(lhs.count, rhs.count)
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointers(rhs, &lhs) { rhsp, lhsp in
        vDSP_vdivD(rhsp + rhs.startIndex, rhs.step, lhsp + lhsStart, lhsStep, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func /<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Double> where ML.Element == Double, MR.Element == Double {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Double>(count: lhs.count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_vdivD(rhsp + rhs.startIndex, rhs.step, lhsp + lhs.startIndex, lhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(count))
    }
    return results
}

public func /=<ML: MutableLinearType>(lhs: inout ML, rhs: Double) where ML.Element == Double {
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointer(&lhs) { lhsp in
        var scalar = rhs
        vDSP_vsdivD(lhsp + lhsStart, lhsStep, &scalar, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func /<ML: LinearType>(lhs: ML, rhs: Double) -> ValueArray<Double> where ML.Element == Double {
    let results = ValueArray<Double>(count: lhs.count)
    withPointer(lhs) { lhsp in
        var scalar = rhs
        vDSP_vsdivD(lhsp + lhs.startIndex, lhs.step, &scalar, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func /<ML: LinearType>(lhs: Double, rhs: ML) -> ValueArray<Double> where ML.Element == Double {
    var lhs = lhs
    let results = ValueArray<Double>(count: rhs.count)
    withPointer(rhs) { rhsp in
        vDSP_svdivD(&lhs, rhsp + rhs.startIndex, rhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(rhs.count))
    }
    return results
}

public func *=<ML: MutableLinearType, MR: LinearType>(lhs: inout ML, rhs: MR) where ML.Element == Double, MR.Element == Double {
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointers(rhs, &lhs) { rhsp, lhsp in
        vDSP_vmulD(lhsp + lhsStart, lhsStep, rhsp + rhs.startIndex, rhs.step, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func *<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Double> where ML.Element == Double, MR.Element == Double {
    let results = ValueArray<Double>(count: lhs.count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_vmulD(lhsp + lhs.startIndex, lhs.step, rhsp + rhs.startIndex, rhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func *=<ML: MutableLinearType>(lhs: inout ML, rhs: Double) where ML.Element == Double {
    var rhs = rhs
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointer(&lhs) { lhsp in
        vDSP_vsmulD(lhsp + lhsStart, lhsStep, &rhs, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func *<ML: LinearType>(lhs: ML, rhs: Double) -> ValueArray<Double> where ML.Element == Double {
    var rhs = rhs
    let results = ValueArray<Double>(count: lhs.count)
    withPointer(lhs) { lhsp in
        vDSP_vsmulD(lhsp + lhs.startIndex, lhs.step, &rhs, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func *<ML: LinearType>(lhs: Double, rhs: ML) -> ValueArray<Double> where ML.Element == Double {
    return rhs * lhs
}

public func %<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Double> where ML.Element == Double, MR.Element == Double {
    return mod(lhs, rhs)
}

public func %<ML: LinearType>(lhs: ML, rhs: Double) -> ValueArray<Double> where ML.Element == Double {
    return mod(lhs, ValueArray<Double>(count: lhs.count, repeatedValue: rhs))
}

infix operator •
public func •<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> Double where ML.Element == Double, MR.Element == Double {
    return dot(lhs, rhs)
}

// MARK: - Float

public func +=<ML: MutableLinearType, MR: LinearType>(lhs: inout ML, rhs: MR) where ML.Element == Float, MR.Element == Float {
    assert(lhs.count >= rhs.count)
    let count = min(lhs.count, rhs.count)
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointers(rhs, &lhs) { rhsp, lhsp in
        vDSP_vadd(lhsp + lhsStart, lhsStep, rhsp + rhs.startIndex, rhs.step, lhsp, lhsStep, vDSP_Length(count))
    }
}

public func +<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Float> where ML.Element == Float, MR.Element == Float {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Float>(count: count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_vadd(lhsp + lhs.startIndex, lhs.step, rhsp + rhs.startIndex, rhs.step, results.mutablePointer, results.step, vDSP_Length(count))
    }
    return results
}

public func +=<ML: MutableLinearType>(lhs: inout ML, rhs: Float) where ML.Element == Float {
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointer(&lhs) { lhsp in
        var scalar = rhs
        vDSP_vsadd(lhsp + lhsStart, lhsStep, &scalar, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func +<ML: LinearType>(lhs: ML, rhs: Float) -> ValueArray<Float> where ML.Element == Float {
    let results = ValueArray<Float>(count: lhs.count)
    withPointer(lhs) { lhsp in
        var scalar = rhs
        vDSP_vsadd(lhsp + lhs.startIndex, lhs.step, &scalar, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func +<MR: LinearType>(lhs: Float, rhs: MR) -> ValueArray<Float> where MR.Element == Float {
    return rhs + lhs
}

public func -=<ML: MutableLinearType, MR: LinearType>(lhs: inout ML, rhs: MR) where ML.Element == Float, MR.Element == Float {
    let count = min(lhs.count, rhs.count)
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointers(rhs, &lhs) { rhsp, lhsp in
        vDSP_vsub(rhsp + rhs.startIndex, rhs.step, lhsp + lhsStart, lhsStep, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func -<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Float> where ML.Element == Float, MR.Element == Float {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Float>(count: count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_vsub(rhsp + rhs.startIndex, rhs.step, lhsp + lhs.startIndex, lhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(count))
    }
    return results
}

public func -=<ML: MutableLinearType>(lhs: inout ML, rhs: Float) where ML.Element == Float {
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointer(&lhs) { lhsp in
        var scalar: Float = -rhs
        vDSP_vsadd(lhsp + lhsStart, lhsStep, &scalar, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func -<ML: LinearType>(lhs: ML, rhs: Float) -> ValueArray<Float> where ML.Element == Float {
    let results = ValueArray<Float>(count: lhs.count)
    withPointer(lhs) { lhsp in
        var scalar: Float = -rhs
        vDSP_vsadd(lhsp + lhs.startIndex, lhs.step, &scalar, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func -<ML: LinearType>(lhs: Float, rhs: ML) -> ValueArray<Float> where ML.Element == Float {
    let results = ValueArray<Float>(count: rhs.count)
    withPointer(rhs) { rhsp in
        var scalarm: Float = -1
        var scalara: Float = lhs
        vDSP_vsmsa(rhsp + rhs.startIndex, rhs.step, &scalarm, &scalara, results.mutablePointer + results.startIndex, results.step, vDSP_Length(rhs.count))
    }
    return results
}

public func /=<ML: MutableLinearType, MR: LinearType>(lhs: inout ML, rhs: MR) where ML.Element == Float, MR.Element == Float {
    let count = min(lhs.count, rhs.count)
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointers(rhs, &lhs) { rhsp, lhsp in
        vDSP_vdiv(rhsp + rhs.startIndex, rhs.step, lhsp + lhsStart, lhsStep, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func /<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Float> where ML.Element == Float, MR.Element == Float {
    let count = min(lhs.count, rhs.count)
    let results = ValueArray<Float>(count: lhs.count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_vdiv(rhsp + rhs.startIndex, rhs.step, lhsp + lhs.startIndex, lhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(count))
    }
    return results
}

public func /=<ML: MutableLinearType>(lhs: inout ML, rhs: Float) where ML.Element == Float {
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointer(&lhs) { lhsp in
        var scalar = rhs
        vDSP_vsdiv(lhsp + lhsStart, lhsStep, &scalar, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func /<ML: LinearType>(lhs: ML, rhs: Float) -> ValueArray<Float> where ML.Element == Float {
    let results = ValueArray<Float>(count: lhs.count)
    withPointer(lhs) { lhsp in
        var scalar = rhs
        vDSP_vsdiv(lhsp + lhs.startIndex, lhs.step, &scalar, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func /<ML: LinearType>(lhs: Float, rhs: ML) -> ValueArray<Float> where ML.Element == Float {
    let results = ValueArray<Float>(count: rhs.count)
    withPointer(rhs) { rhsp in
        var scalar = lhs
        vDSP_svdiv(&scalar, rhsp + rhs.startIndex, rhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(rhs.count))
    }
    return results
}

public func *=<ML: MutableLinearType, MR: LinearType>(lhs: inout ML, rhs: MR) where ML.Element == Float, MR.Element == Float {
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointers(rhs, &lhs) { rhsp, lhsp in
        vDSP_vmul(lhsp + lhsStart, lhsStep, rhsp + rhs.startIndex, rhs.step, lhsp + lhsStart, lhsStep, vDSP_Length(count))
        }
}

public func *<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Float> where ML.Element == Float, MR.Element == Float {
    let results = ValueArray<Float>(count: lhs.count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_vmul(lhsp + lhs.startIndex, lhs.step, rhsp + rhs.startIndex, rhs.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func *=<ML: MutableLinearType>(lhs: inout ML, rhs: Float) where ML.Element == Float {
    let count = lhs.count
    let lhsStart = lhs.startIndex
    let lhsStep = lhs.step
    withPointer(&lhs) { lhsp in
        var scalar = rhs
        vDSP_vsmul(lhsp + lhsStart, lhsStep, &scalar, lhsp + lhsStart, lhsStep, vDSP_Length(count))
    }
}

public func *<ML: LinearType>(lhs: ML, rhs: Float) -> ValueArray<Float> where ML.Element == Float {
    let results = ValueArray<Float>(count: lhs.count)
    withPointer(lhs) { lhsp in
        var scalar = rhs
        vDSP_vsmul(lhsp + lhs.startIndex, lhs.step, &scalar, results.mutablePointer + results.startIndex, results.step, vDSP_Length(lhs.count))
    }
    return results
}

public func *<ML: LinearType>(lhs: Float, rhs: ML) -> ValueArray<Float> where ML.Element == Float {
    return rhs * lhs
}

public func %<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> ValueArray<Float> where ML.Element == Float, MR.Element == Float {
    return mod(lhs, rhs)
}

public func %<ML: LinearType>(lhs: ML, rhs: Float) -> ValueArray<Float> where ML.Element == Float {
    return mod(lhs, ValueArray<Float>(count: lhs.count, repeatedValue: rhs))
}

public func •<ML: LinearType, MR: LinearType>(lhs: ML, rhs: MR) -> Float where ML.Element == Float, MR.Element == Float {
    return dot(lhs, rhs)
}
