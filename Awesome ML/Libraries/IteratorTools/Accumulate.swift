//
//  Accumulate.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/24/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


public extension Sequence {

    /**
     Returns an array of containing consecutively accumulated values from the sequence.
     ```
     let values = [1, 2, 3, 4].accumulate(+)
     // [1, 3, 6, 10]
     ```
     - Parameter nextPartialResult: The function used to accumulate the sequence's values.
     - Returns: An array of containing consecutively accumulated values from the sequence.
     */
    func accumulate(_ nextPartialResult: @escaping (Iterator.Element, Iterator.Element) -> Iterator.Element) -> [Iterator.Element] {
        return Array(Accumulator(sequence: self, accumulate: nextPartialResult))
    }
}


public extension LazySequenceProtocol {

    /**
     Returns an iterator-sequence for consecutively accumulating the sequence's values.
     ```
     let values = [1, 2, 3, 4].lazy.accumulate(+)
     // 1, 3, 6, 10
     ```
     - Parameter nextPartialResult: The function used to accumulate the sequence's values.
     - Returns: An iterator-sequence consecutively accumulating the sequence's values.
     */
    func accumulate(_ nextPartialResult: @escaping (Iterator.Element, Iterator.Element) -> Iterator.Element) -> Accumulator<Self> {
        return Accumulator(sequence: self, accumulate: nextPartialResult)
    }
}


/// An iterator-sequence for accumulating sequence values. 
/// See the `accumulate(_:)` Sequence and LazySequenceProtocol method.
public struct Accumulator<S: Sequence>: IteratorProtocol, Sequence {

    private let sequence: S
    private var iterator: S.Iterator
    private let accumulate: (S.Iterator.Element, S.Iterator.Element) -> S.Iterator.Element
    private var total: S.Iterator.Element? = nil

    fileprivate init(sequence: S, accumulate: @escaping (S.Iterator.Element, S.Iterator.Element) -> S.Iterator.Element) {
        self.sequence = sequence
        self.iterator = sequence.makeIterator()
        self.accumulate = accumulate
    }

    public mutating func next() -> S.Iterator.Element? {
        guard let next = iterator.next() else {
            return nil
        }

        if let total = total {
            self.total = accumulate(total, next)
        } else {
            self.total = next
        }

        return total
    }
}
