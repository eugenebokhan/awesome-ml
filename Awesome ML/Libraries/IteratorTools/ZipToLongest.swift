//
//  ZipToLongest.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/**
 Returns an iterator-sequence that aggregates elements from each of the sequences. 
 If the sequences are of uneven length, missing values are filled-in with the corresponding fill value. 
 Iteration continues until the longest sequence is exhausted.
 ```
 let values = zipToLongest([1, 2], ["a", "b", "c"], firstFillValue: 0, secondFillValue: "z"
 // (1, "a"), (2, "b"), (0, "c")

 let values = zipToLongest([1, 2, 3, 4], ["a", "b"], firstFillValue: 0, secondFillValue: "z")
 // (1, "a"), (2, "b"), (3, "z"), (4, "z")
 ```
 - Parameters:
    - firstSequence: The first of the sequences from which to aggregate elements.
    - secondSequence: The second of the sequences from which to aggregate elements.
    - firstFillValue: The value to use as a filler in zipping when the second sequence is longer than the first.
    - secondFillValue: The value to use as a filler in zipping when the first sequence is longer than the second.
 - Returns: An iterator-sequence that aggregates elements from each of the sequences.
 */
public func zipToLongest<S1: Sequence, S2: Sequence>(_ firstSequence: S1, _ secondSequence: S2, firstFillValue: S1.Iterator.Element, secondFillValue: S2.Iterator.Element) -> ZipToLongest<S1, S2> {
        return ZipToLongest(firstSequence, secondSequence, firstFillValue: firstFillValue, secondFillValue: secondFillValue)
}


/// An iterator-sequence that aggregates elements from two sequences, filling in with values when one sequence is longer than the other.
/// See `zipToLongest(_:_:firstFillValue:secondFillValue:)`.
public struct ZipToLongest<S1: Sequence, S2: Sequence>: IteratorProtocol, Sequence {

    private var firstIterator: S1.Iterator
    private var secondIterator: S2.Iterator
    private let firstFillValue: S1.Iterator.Element
    private let secondFillValue: S2.Iterator.Element

    fileprivate init(_ sequence1: S1, _ sequence2: S2, firstFillValue: S1.Iterator.Element, secondFillValue: S2.Iterator.Element) {
        self.firstIterator = sequence1.makeIterator()
        self.secondIterator = sequence2.makeIterator()
        self.firstFillValue = firstFillValue
        self.secondFillValue = secondFillValue
    }

    public mutating func next() -> (S1.Iterator.Element, S2.Iterator.Element)? {
        let firstValue = firstIterator.next()
        let secondValue = secondIterator.next()
        guard firstValue != nil || secondValue != nil else {
            return nil
        }
        return (firstValue ?? firstFillValue, secondValue ?? secondFillValue)
    }
}
