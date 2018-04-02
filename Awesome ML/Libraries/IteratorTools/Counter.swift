//
//  Counter.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/24/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/**
 Returns an iterator-sequence beginning at `start` and incrementing by `step`.
 ```
 let values = counter(start: 1, step: 2)
 // 1, 3, 5, 7, 9, ...
 ```
 - Parameters:
    - start: The starting value for the counter.
    - step: The value by which to increment.
 - Returns: An iterator-sequence beginning at `start` and incrementing by `step`.
 */
public func counter(start: Double = 0, step: Double = 1) -> Counter {
    return Counter(start: start, step: step)
}


/// An iterator-sequence that functions as a simple incremental counter. 
/// See `counter(start:step:)`
public struct Counter: IteratorProtocol, LazySequenceProtocol {

    private var start: Double
    private let step: Double

    fileprivate init(start: Double, step: Double) {
        self.start = start
        self.step = step
    }

    public mutating func next() -> Double? {
        defer { start += step }
        return start
    }
}
