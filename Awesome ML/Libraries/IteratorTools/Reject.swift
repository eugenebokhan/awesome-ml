//
//  Reject.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


public extension Sequence {

    /**
     Returns an array containing only the elements from the sequence for which the predicate is false.
     ```
     let values = [1, 2, 3, 4, 5].reject { $0 % 2 == 0 }
     // [1, 3, 5]
     ```
     - Parameter predicate: The predicate used to determine whether the elements should be included in the result. 
        Elements are included only when the predicate is false.
     - Returns: An array containing only the elements from the sequence for which the predicate is false.
     */
    func reject(predicate: @escaping (Iterator.Element) -> Bool) -> [Iterator.Element] {
        return filter { !predicate($0) }
    }
}


public extension LazySequenceProtocol {

    /**
     Returns an iterator-sequence that returns only the elements from the sequence for which the predicate is false.
     ```
     let values = [1, 2, 3, 4, 5].lazy.reject { $0 % 2 == 0 }
     // 1, 3, 5
     ```
     - Parameter predicate: The predicate used to determine whether the elements should be included in the result.
        Elements are included only when the predicate is false.
     - Returns: An iterator-sequence that returns only the elements from the sequence for which the predicate is false.
     */
    func reject(predicate: @escaping (Iterator.Element) -> Bool) -> Rejector<Self> {
        return Rejector(sequence: self, predicate: predicate)
    }
}


/// An iterator-sequence that rejects values that do not meet the predicate. 
/// See the `reject(predicate:)` LazySequenceProtocol method.
public struct Rejector<S: Sequence>: IteratorProtocol, Sequence {

    private var iterator: S.Iterator
    private let predicate: (S.Iterator.Element) -> Bool

    fileprivate init(sequence: S, predicate: @escaping (S.Iterator.Element) -> Bool) {
        self.iterator = sequence.makeIterator()
        self.predicate = predicate
    }

    public mutating func next() -> S.Iterator.Element? {
        guard let next = iterator.next() else {
            return nil
        }

        return !predicate(next) ? next : self.next()
    }
}
