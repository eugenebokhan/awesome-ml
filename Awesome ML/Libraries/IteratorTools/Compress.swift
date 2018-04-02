//
//  Compress.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/**
 Returns an iterator-sequence that filters elements from `data`, returning only those that have a corresponding `true` in `selectors`.
 Stops when either `data` or `selectors` has been exhausted.
 ```
 let values = compress(data: [1, 2, 3, 4], selectors: [true, true, false, true])
 // 1, 2, 4
 ```
 - Parameters:
    - data: The data to filter.
    - selectors: The selectors used in filtering the data.
 - Returns: An iterator-sequence that filters elements from `data`, returning only those that have a corresponding `true` in `selectors`.
 */
public func compress<S1, S2>(data: S1, selectors: S2) -> Compressor<S1, S2> {
    return Compressor(data: data, selectors: selectors)
}


/// An iterator-sequence for filtering data based on corresponding selectors. 
/// See `compress(data:selectors:)`.
public struct Compressor<S1: Sequence, S2: Sequence>: IteratorProtocol, Sequence where S2.Iterator.Element == Bool {

    private var dataIterator: S1.Iterator
    private var selectorIterator: S2.Iterator

    fileprivate init(data: S1, selectors: S2) {
        self.dataIterator = data.makeIterator()
        self.selectorIterator = selectors.makeIterator()
    }

    public mutating func next() -> S1.Iterator.Element? {
        guard let nextData = dataIterator.next(), let nextSelector = selectorIterator.next() else {
            return nil
        }

        guard nextSelector else {
            return next()
        }

        return nextData
    }
}
