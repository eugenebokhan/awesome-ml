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

open class FFTDouble {
    fileprivate var setup: FFTSetupD
    open fileprivate(set) var maxLength: vDSP_Length

    fileprivate var real: ValueArray<Double>
    fileprivate var imag: ValueArray<Double>

    public init(inputLength: Int) {
        assert(inputLength.nonzeroBitCount == 1, "input length must be a power of 2")
        let maxLengthLog2 = vDSP_Length(log2(Double(inputLength))) + 1
        maxLength = vDSP_Length(exp2(Double(maxLengthLog2)))
        setup = vDSP_create_fftsetupD(maxLengthLog2, FFTRadix(kFFTRadix2))!

        real = ValueArray<Double>(count: Int(maxLength))
        imag = ValueArray<Double>(count: Int(maxLength))
    }

    deinit {
        vDSP_destroy_fftsetupD(setup)
    }

    /// Performs a real to complex forward FFT
    open func forward<M: LinearType>(_ input: M) -> ComplexArray<Double> where M.Element == Double {
        let lengthLog2 = vDSP_Length(log2(Double(input.count)))
        let length = vDSP_Length(exp2(Double(lengthLog2)))
        var results = ComplexArray<Double>(count: Int(length) / 2)
        forward(input, results: &results)
        return results
    }

    /// Performs a real to complex forward FFT
    open func forward<M: LinearType>(_ input: M, results: inout ComplexArray<Double>) where M.Element == Double {
        let lengthLog2 = vDSP_Length(log2(Double(input.count)))
        let length = vDSP_Length(exp2(Double(lengthLog2)))
        precondition(length <= maxLength/2, "Input should have at most \(maxLength/2) elements")

        real.assignFrom(input)
        for i in 0..<input.count {
            imag.mutablePointer[i] = 0.0
        }

        var splitComplex = DSPDoubleSplitComplex(realp: real.mutablePointer, imagp: imag.mutablePointer)
        vDSP_fft_zipD(setup, &splitComplex, 1, lengthLog2, FFTDirection(FFT_FORWARD))

        let capacity = results.capacity
        precondition(capacity >= Int(length) / 2)
        results.count = Int(length) / 2
        withPointer(&results) { pointer in
            pointer.withMemoryRebound(to: DSPDoubleComplex.self, capacity: capacity) { resultsPointer in
                vDSP_ztocD(&splitComplex, 1, resultsPointer, 1, length/2)
            }
        }

        let scale = 2.0 / Double(input.count)
        results *= scale
    }

    /// Performs a real to real forward FFT by taking the square magnitudes of the complex result
    open func forwardMags<M: LinearType>(_ input: M) -> ValueArray<Double> where M.Element == Double {
        let lengthLog2 = vDSP_Length(log2(Double(input.count)))
        let length = vDSP_Length(exp2(Double(lengthLog2)))
        var results = ValueArray<Double>(count: Int(length))
        forwardMags(input, results: &results)
        return results
    }

    /// Performs a real to real forward FFT by taking the square magnitudes of the complex result
    open func forwardMags<M: LinearType>(_ input: M, results: inout ValueArray<Double>) where M.Element == Double {
        let lengthLog2 = vDSP_Length(log2(Double(input.count)))
        let length = vDSP_Length(exp2(Double(lengthLog2)))
        precondition(length <= maxLength/2, "Input should have at most \(maxLength/2) elements")

        real.assignFrom(input)
        for i in 0..<input.count {
            imag.mutablePointer[i] = 0.0
        }

        var splitComplex = DSPDoubleSplitComplex(realp: real.mutablePointer, imagp: imag.mutablePointer)
        vDSP_fft_zipD(setup, &splitComplex, 1, lengthLog2, FFTDirection(FFT_FORWARD))

        precondition(results.capacity >= input.count / 2)
        results.count = input.count / 2
        vDSP_zvmagsD(&splitComplex, 1, results.mutablePointer, 1, length/2)

        let scale = 2.0 / Double(input.count)
        results *= scale * scale
    }
}

open class FFTFloat {
    fileprivate var setup: FFTSetup
    open fileprivate(set) var maxLength: vDSP_Length

    fileprivate var real: ValueArray<Float>
    fileprivate var imag: ValueArray<Float>

    public init(inputLength: Int) {
        assert(inputLength.nonzeroBitCount == 1, "input length must be a power of 2")
        let maxLengthLog2 = vDSP_Length(log2(Float(inputLength))) + 1
        maxLength = vDSP_Length(exp2(Float(maxLengthLog2)))
        setup = vDSP_create_fftsetup(maxLengthLog2, FFTRadix(kFFTRadix2))!

        real = ValueArray<Float>(count: Int(maxLength))
        imag = ValueArray<Float>(count: Int(maxLength))
    }

    deinit {
        vDSP_destroy_fftsetup(setup)
    }

    /// Performs a real to complex forward FFT
    open func forward<M: LinearType>(_ input: M) -> ComplexArray<Float> where M.Element == Float {
        let lengthLog2 = vDSP_Length(log2(Float(input.count)))
        let length = vDSP_Length(exp2(Float(lengthLog2)))
        precondition(length <= maxLength/2, "Input should have at most \(maxLength/2) elements")

        real.assignFrom(input)
        for i in 0..<input.count {
            imag.mutablePointer[i] = 0.0
        }

        var splitComplex = DSPSplitComplex(realp: real.mutablePointer, imagp: imag.mutablePointer)
        vDSP_fft_zip(setup, &splitComplex, 1, lengthLog2, FFTDirection(FFT_FORWARD))

        var result = ComplexArray<Float>(count: Int(length)/2)
        withPointer(&result) { pointer in
            pointer.withMemoryRebound(to: DSPComplex.self, capacity: Int(length)/2) { pointer in
                vDSP_ztoc(&splitComplex, 1, pointer, 1, length/2)
            }
        }

        let scale = 2.0 / Float(input.count)
        return result * scale
    }

    /// Performs a real to real forward FFT by taking the square magnitudes of the complex result
    open func forwardMags<M: LinearType>(_ input: M) -> ValueArray<Float> where M.Element == Float {
        let lengthLog2 = vDSP_Length(log2(Float(input.count)))
        let length = vDSP_Length(exp2(Float(lengthLog2)))
        precondition(length <= maxLength/2, "Input should have at most \(maxLength/2) elements")

        real.assignFrom(input)
        for i in 0..<input.count {
            imag.mutablePointer[i] = 0.0
        }

        var splitComplex = DSPSplitComplex(realp: real.mutablePointer, imagp: imag.mutablePointer)
        vDSP_fft_zip(setup, &splitComplex, 1, lengthLog2, FFTDirection(FFT_FORWARD))

        let magnitudes = ValueArray<Float>(count: input.count/2)
        vDSP_zvmags(&splitComplex, 1, magnitudes.mutablePointer, 1, length/2)

        let scale = 2.0 / Float(input.count)
        return magnitudes * scale * scale
    }
}
