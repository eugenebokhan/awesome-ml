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

import Darwin

public struct Complex<Element: Real>: Value {
    public var real: Element
    public var imag: Element

    public init() {
        self.init(real: 0, imag: 0)
    }

    public init(integerLiteral value: Int) {
        self.init(real: Element(value), imag: 0)
    }

    public init(real: Element, imag: Element) {
        self.real = real
        self.imag = imag
    }

    public var magnitude: Element {
        if let real = real as? Double, let imag = imag as? Double {
            return hypot(real, imag) as! Element
        } else if let real = real as? Float, let imag = imag as? Float {
            return hypot(real, imag) as! Element
        }
        fatalError()
    }

    public var phase: Element {
        if let real = real as? Double, let imag = imag as? Double {
            return atan2(imag, real) as! Element
        } else if let real = real as? Float, let imag = imag as? Float {
            return atan2(imag, real) as! Element
        }
        fatalError()
    }

    public static func abs(_ x: Complex) -> Complex {
        return Complex(real: x.magnitude, imag: 0.0)
    }

    public var hashValue: Int {
        return real.hashValue ^ imag.hashValue
    }

    public var description: String {
        return "\(real) + \(imag)i"
    }

    public static func == (lhs: Complex, rhs: Complex) -> Bool {
        return lhs.real == rhs.real && lhs.imag == rhs.imag
    }

    public static func < (lhs: Complex, rhs: Complex) -> Bool {
        return lhs.real < rhs.real || (lhs.real == rhs.real && lhs.imag < rhs.imag)
    }

    public static func + (lhs: Complex, rhs: Complex) -> Complex<Element> {
        return Complex(real: lhs.real + rhs.real, imag: lhs.imag + rhs.imag)
    }

    public static func - (lhs: Complex, rhs: Complex) -> Complex<Element> {
        return Complex(real: lhs.real - rhs.real, imag: lhs.imag - rhs.imag)
    }

    public static func * (lhs: Complex, rhs: Complex) -> Complex<Element> {
        return Complex(real: lhs.real * rhs.real - lhs.imag * rhs.imag, imag: lhs.real * rhs.imag + lhs.imag * rhs.real)
    }

    public static func * (x: Complex, a: Element) -> Complex<Element> {
        return Complex(real: x.real * a, imag: x.imag * a)
    }

    public static func * (a: Element, x: Complex) -> Complex<Element> {
        return Complex(real: x.real * a, imag: x.imag * a)
    }

    public static func / (lhs: Complex, rhs: Complex) -> Complex<Element> {
        let rhsMagSq = rhs.real*rhs.real + rhs.imag*rhs.imag
        return Complex(
            real: (lhs.real*rhs.real + lhs.imag*rhs.imag) / rhsMagSq,
            imag: (lhs.imag*rhs.real - lhs.real*rhs.imag) / rhsMagSq)
    }

    public static func / (x: Complex, a: Element) -> Complex<Element> {
        return Complex(real: x.real / a, imag: x.imag / a)
    }

    public static func / (a: Element, x: Complex) -> Complex<Element> {
        let xMagSq = x.real*x.real + x.imag*x.imag
        return Complex(real: a*x.real / xMagSq, imag: -a*x.imag / xMagSq)
    }
}
