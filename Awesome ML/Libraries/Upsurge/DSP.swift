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

/**
    Convolution between a signal and a kernel. The signal should have at least as many elements as the kernel. The
    result will have `N - M + 1` elements where `N` is the size of the signal and `M` is the size of the kernel.
*/
public func convolution<MS: LinearType, MK: LinearType>(_ signal: MS, _ kernel: MK) -> ValueArray<Double> where MS.Element == Double, MK.Element == Double {
    precondition(signal.count >= kernel.count, "The signal should have at least as many elements as the kernel")

    let resultSize = signal.count - kernel.count + 1
    let result = ValueArray<Double>(count: resultSize)
    withPointers(signal, kernel) { signalP, kernelP in
        let kernelLast = kernelP + kernel.count - 1
        vDSP_convD(signalP + signal.startIndex, signal.step, kernelLast, -kernel.step, result.mutablePointer, result.step, vDSP_Length(resultSize), vDSP_Length(kernel.count))
    }
    return result
}

/**
    Correlation between two vectors. The first vector should have at least as many elements as the second. The result
    will have `N - M + 1` elements where `N` is the size of the first vector and `M` is the size of the second.
*/
public func correlation<ML: LinearType, MR: LinearType>(_ lhs: ML, _ rhs: MR) -> ValueArray<Double> where ML.Element == Double, MR.Element == Double {
    precondition(lhs.count >= rhs.count, "The first vector should have at least as many elements as the second")

    let resultSize = lhs.count - rhs.count + 1
    let result = ValueArray<Double>(count: resultSize)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_convD(lhsp + lhs.startIndex, lhs.step, rhsp + rhs.startIndex, rhs.step, result.mutablePointer, result.step, vDSP_Length(resultSize), vDSP_Length(rhs.count))
    }
    return result
}

/**
    Autocorrelation function. This function finds the correlation of a signal with itself shifted by increasing lags.
    Since autocorrelation is symetric, this function returns only positive lags up to the specified maximum lag. The
    maximum lag has to be smaller than the size of the signal.

    - parameter x: The signal
    - parameter maxLag: The maximum lag to use.
*/
public func autocorrelation<M: LinearType>(_ x: M, maxLag: Int) -> ValueArray<Double> where M.Element == Double {
    precondition(maxLag < x.count)

    let signalSize = x.count + maxLag
    let signal = ValueArray<Double>(count: signalSize, repeatedValue: 0.0)
    withPointer(x) { xp in
        for i in 0..<x.count {
            signal.mutablePointer[i] = xp[x.startIndex + i*x.step]
        }
    }
    return correlation(signal, x)
}

// MARK: - Float

/**
Convolution between a signal and a kernel. The signal should have at least as many elements as the kernel. The
result will have `N - M + 1` elements where `N` is the size of the signal and `M` is the size of the kernel.
*/
public func convolution<MS: LinearType, MK: LinearType>(_ signal: MS, _ kernel: MK) -> ValueArray<Float> where MS.Element == Float, MK.Element == Float {
    precondition(signal.count >= kernel.count, "The signal should have at least as many elements as the kernel")

    let resultSize = signal.count - kernel.count + 1
    let result = ValueArray<Float>(count: resultSize)
    withPointers(signal, kernel) { signalP, kernelP in
        let kernelLast = kernelP + kernel.count - 1
        vDSP_conv(signalP + signal.startIndex, signal.step, kernelLast, -kernel.step, result.mutablePointer, result.step, vDSP_Length(resultSize), vDSP_Length(kernel.count))
    }
    return result
}

/**
 Correlation between two vectors. The first vector should have at least as many elements as the second. The result
 will have `N - M + 1` elements where `N` is the size of the first vector and `M` is the size of the second.
 */
public func correlation<ML: LinearType, MR: LinearType>(_ lhs: ML, _ rhs: MR) -> ValueArray<Float> where ML.Element == Float, MR.Element == Float {
    precondition(lhs.count >= rhs.count, "The first vector should have at least as many elements as the second")

    let resultSize = lhs.count - rhs.count + 1
    let result = ValueArray<Float>(count: resultSize)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_conv(lhsp + lhs.startIndex, lhs.step, rhsp + rhs.startIndex, rhs.step, result.mutablePointer, result.step, vDSP_Length(resultSize), vDSP_Length(rhs.count))
    }
    return result
}

/**
 Autocorrelation function. This function finds the correlation of a signal with itself shifted by increasing lags.
 Since autocorrelation is symetric, this function returns only positive lags up to the specified maximum lag. The
 maximum lag has to be smaller than the size of the signal.

 - parameter x: The signal
 - parameter maxLag: The maximum lag to use.
 */
public func autocorrelation<M: LinearType>(_ x: M, maxLag: Int) -> ValueArray<Float> where M.Element == Float {
    precondition(maxLag < x.count)

    let signalSize = x.count + maxLag
    let signal = ValueArray<Float>(count: signalSize, repeatedValue: 0.0)
    withPointer(x) { xp in
        for i in 0..<x.count {
            signal.mutablePointer[i] = xp[x.startIndex + i*x.step]
        }
    }
    return correlation(signal, x)
}
