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

// MARK: - Double

public func sum(_ x: ComplexArray<Double>) -> Complex<Double> {
    return Complex(real: sum(x.reals), imag: sum(x.imags))
}

// MARK: Operators

public func += (lhs: inout ComplexArray<Double>, rhs: ComplexArray<Double>) {
    lhs.reals += rhs.reals
    lhs.imags += rhs.imags
}

public func + (lhs: ComplexArray<Double>, rhs: ComplexArray<Double>) -> ComplexArray<Double> {
    var results = ComplexArray(lhs)
    results += rhs
    return results
}

public func -= (lhs: inout ComplexArray<Double>, rhs: ComplexArray<Double>) {
    lhs.reals -= rhs.reals
    lhs.imags -= rhs.imags
}

public func - (lhs: ComplexArray<Double>, rhs: ComplexArray<Double>) -> ComplexArray<Double> {
    var results = ComplexArray(lhs)
    results -= rhs
    return results
}

public func += (lhs: inout ComplexArray<Double>, rhs: Complex<Double>) {
    lhs.reals += rhs.real
    lhs.imags += rhs.imag
}

public func + (lhs: ComplexArray<Double>, rhs: Complex<Double>) -> ComplexArray<Double> {
    var results = ComplexArray(lhs)
    results += rhs
    return results
}

public func + (lhs: Complex<Double>, rhs: ComplexArray<Double>) -> ComplexArray<Double> {
    var results = ComplexArray(rhs)
    results += lhs
    return results
}

public func -= (lhs: inout ComplexArray<Double>, rhs: Complex<Double>) {
    lhs.reals -= rhs.real
    lhs.imags -= rhs.imag
}

public func - (lhs: ComplexArray<Double>, rhs: Complex<Double>) -> ComplexArray<Double> {
    var results = ComplexArray(lhs)
    results -= rhs
    return results
}

public func - (lhs: Complex<Double>, rhs: ComplexArray<Double>) -> ComplexArray<Double> {
    var results = ComplexArray(rhs)
    results -= lhs
    return results
}

public func *= (lhs: inout ComplexArray<Double>, rhs: Double) {
    lhs.reals *= rhs
    lhs.imags *= rhs
}

public func * (lhs: ComplexArray<Double>, rhs: Double) -> ComplexArray<Double> {
    var results = ComplexArray(lhs)
    results *= rhs
    return results
}

public func /= (lhs: inout ComplexArray<Double>, rhs: Double) {
    lhs.reals /= rhs
    lhs.imags /= rhs
}

public func / (lhs: ComplexArray<Double>, rhs: Double) -> ComplexArray<Double> {
    var results = ComplexArray(lhs)
    results /= rhs
    return results
}

// MARK: - Float

public func sum(_ x: ComplexArray<Float>) -> Complex<Float> {
    return Complex<Float>(real: sum(x.reals), imag: sum(x.imags))
}

// MARK: Operators

public func += (lhs: inout ComplexArray<Float>, rhs: ComplexArray<Float>) {
    lhs.reals += rhs.reals
    lhs.imags += rhs.imags
}

public func + (lhs: ComplexArray<Float>, rhs: ComplexArray<Float>) -> ComplexArray<Float> {
    var results = ComplexArray(lhs)
    results += rhs
    return results
}

public func -= (lhs: inout ComplexArray<Float>, rhs: ComplexArray<Float>) {
    lhs.reals -= rhs.reals
    lhs.imags -= rhs.imags
}

public func - (lhs: ComplexArray<Float>, rhs: ComplexArray<Float>) -> ComplexArray<Float> {
    var results = ComplexArray(lhs)
    results -= rhs
    return results
}

public func += (lhs: inout ComplexArray<Float>, rhs: Complex<Float>) {
    lhs.reals += rhs.real
    lhs.imags += rhs.imag
}

public func + (lhs: ComplexArray<Float>, rhs: Complex<Float>) -> ComplexArray<Float> {
    var results = ComplexArray(lhs)
    results += rhs
    return results
}

public func + (lhs: Complex<Float>, rhs: ComplexArray<Float>) -> ComplexArray<Float> {
    var results = ComplexArray(rhs)
    results += lhs
    return results
}

public func -= (lhs: inout ComplexArray<Float>, rhs: Complex<Float>) {
    lhs.reals -= rhs.real
    lhs.imags -= rhs.imag
}

public func - (lhs: ComplexArray<Float>, rhs: Complex<Float>) -> ComplexArray<Float> {
    var results = ComplexArray(lhs)
    results -= rhs
    return results
}

public func - (lhs: Complex<Float>, rhs: ComplexArray<Float>) -> ComplexArray<Float> {
    var results = ComplexArray(rhs)
    results -= lhs
    return results
}

public func *= (lhs: inout ComplexArray<Float>, rhs: Float) {
    lhs.reals *= rhs
    lhs.imags *= rhs
}

public func * (lhs: ComplexArray<Float>, rhs: Float) -> ComplexArray<Float> {
    var results = ComplexArray(lhs)
    results *= rhs
    return results
}

public func /= (lhs: inout ComplexArray<Float>, rhs: Float) {
    lhs.reals /= rhs
    lhs.imags /= rhs
}

public func / (lhs: ComplexArray<Float>, rhs: Float) -> ComplexArray<Float> {
    var results = ComplexArray(lhs)
    results /= rhs
    return results
}
