//
//  Grouped.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


public extension Sequence {

    /**
     Returns an array of consecutive keys and groups from the sequence as tuples.
     Groups are made based on the element's output from the given key function.
     A group is cut as soon as the sequence's next value produces a different key.
     Generally, the sequence should be sorted on the same key function to group all values with the same key.
     ```
     let values = (0...10).sorted(by: { $0 % 3 < $1 % 3 }).grouped(by: { $0 % 3 })
     // [(key: 0, elements: [0, 3, 6, 9]), (key: 1, elements: [1, 4, 7, 10]), (key: 2, elements: [2, 5, 8])]
     ```
     - Parameter key: The key function used in determining groups.
     - Returns: An array of consecutive keys and groups from the sequence.
     */
    func grouped<Key: Equatable>(by key: @escaping (Iterator.Element) -> Key) -> [(key: Key, elements: [Iterator.Element])] {
        return Array(Grouper(sequence: self, key: key))
    }
}

public extension LazySequenceProtocol {

    /**
     Returns an iterator-sequence that returns consecutive keys and groups from the sequence as tuples.
     Groups are made based on the element's output from the given key function.
     A group is cut as soon as the sequence's next value produces a different key.
     Generally, the sequence should be sorted on the same key function to group all values with the same key.
     ```
     let values = (0...10).sorted(by: { $0 % 3 < $1 % 3 }).lazy.grouped(by: { $0 % 3 })
     // (key: 0, elements: [0, 3, 6, 9]), (key: 1, elements: [1, 4, 7, 10]), (key: 2, elements: [2, 5, 8])
     ```
     - Parameter key: The key function used in determining groups.
     - Returns: An iterator-sequence that returns consecutive keys and groups from the sequence.
     */
    func grouped<Key: Equatable>(by key: @escaping (Iterator.Element) -> Key) -> Grouper<Self, Key> {
        return Grouper(sequence: self, key: key)
    }
}


/// An iterator-sequence that returns consecutive keys and groups from a sequence as tuples. 
/// See the `grouped(by:)` Sequence method.
public struct Grouper<S: Sequence, Key: Equatable>: IteratorProtocol, Sequence {

    private var iterator: S.Iterator
    private let key: (S.Iterator.Element) -> Key
    private var currentKey: Key?
    private var currentValues: [S.Iterator.Element] = []

    fileprivate init(sequence: S, key: @escaping (S.Iterator.Element) -> Key) {
        self.iterator = sequence.makeIterator()
        self.key = key
    }

    public mutating func next() -> (key: Key, elements: [S.Iterator.Element])? {
        if currentKey == nil {
            guard let next = iterator.next() else {
                return nil
            }
            currentKey = key(next)
            currentValues = [next]
        }

        while let next = iterator.next() {
            let nextKey = key(next)
            if nextKey == currentKey {
                currentValues.append(next)
            } else {
                let lastKey = currentKey!
                let lastValues = currentValues
                currentKey = nextKey
                currentValues = [next]
                return (lastKey, lastValues)
            }
        }

        guard !currentValues.isEmpty else {
            return nil
        }

        let lastKey = currentKey!
        let lastValues = currentValues
        currentKey = nil
        currentValues = []
        return (lastKey, lastValues)
    }
}
