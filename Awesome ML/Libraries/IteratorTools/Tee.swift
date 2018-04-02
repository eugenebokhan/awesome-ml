//
//  Tee.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


public extension Sequence {

    /**
     Returns an array of `n` independent iterators from the sequence.
     - Parameter n: The number of iterators to produce.
     - Returns: An array of `n` independent iterators from the sequence.
     */
    func tee(_ n: Int = 2) -> [Iterator] {
        return Array(repeating: makeIterator(), count: n)
    }
}


public extension LazySequenceProtocol {

    /**
     Returns an iterator-sequence of `n` independent iterators from the sequence.
     - Parameter n: The number of iterators to produce.
     - Returns: An iterator-sequence of `n` indepdent iterators from the sequence
     */
    func tee(_ n: Int = 2) -> Tee<Self> {
        return Tee(sequence: self, times: n)
    }
}


/// An iterator-sequence of a specified number of independent iterators from the sequence.
/// See the `tee(_:)` Sequence and LazySequenceProtocol method.
public struct Tee<S: Sequence>: IteratorProtocol, Sequence {

    private let sequence: S
    private var times: Int

    fileprivate init(sequence: S, times: Int) {
        self.sequence = sequence
        self.times = times
    }

    public mutating func next() -> S.Iterator? {
        defer { times -= 1 }
        return times == 0 ? nil : sequence.makeIterator()
    }
}
