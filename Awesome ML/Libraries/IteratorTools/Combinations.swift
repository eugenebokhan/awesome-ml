//
//  Combinations.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/28/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


public extension Sequence {

    /**
     Returns an array containing the combinations of the specified length of elements in the sequence.
     ```
     let values = [1, 2, 3, 4].combinations(length: 2, repeatingElements: false)
     // [[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]

     let values = [1, 2, 3, 4].combinations(length: 2, repeatingElements: true)
     // [[1, 1], [1, 2], [1, 3], [1, 4], [2, 2], [2, 3], [2, 4], [3, 3], [3, 4]]
     ```
     - Parameters:
        - length: The length of the combinations to return.
        - repeatingElements: A boolean value determining whether or not elements can repeat in a combination.
     - Returns: An array containing the combinations of the specified length of elements in the sequence.
     */
    func combinations(length: Int, repeatingElements: Bool) -> [[Iterator.Element]] {
        return Array(Combinations(sequence: self, length: length, repeatingElements: repeatingElements))
    }
}


public extension LazySequenceProtocol {

    /**
     Returns an iterator-sequence that returns the combinations of the specified length of elements in the sequence.
     ```
     let values = [1, 2, 3, 4].lazy.combinations(length: 2, repeatingElements: false)
     // [1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]

     let values = [1, 2, 3, 4].lazy.combinations(length: 2, repeatingElements: true)
     // [1, 1], [1, 2], [1, 3], [1, 4], [2, 2], [2, 3], [2, 4], [3, 3], [3, 4]
     ```
     - Parameters:
        - length: The length of the combinations to return.
        - repeatingElements: A boolean value determining whether or not elements can repeat in a combination.
     - Returns: An an iterator-sequence that returns the combinations of the specified length of elements in the sequence.
     */
    func combinations(length: Int, repeatingElements: Bool) -> Combinations<Self> {
        return Combinations(sequence: self, length: length, repeatingElements: repeatingElements)
    }
}


/// An iterator-sequence that returns the combinations of a specified length of elements in a sequence.
/// See the `combinations(length:repeatingElements:)` Sequence and LazySequenceProtocol method.
public struct Combinations<S: Sequence>: IteratorProtocol, Sequence {

    private let values: [S.Iterator.Element]
    private let combinationLength: Int
    private let repeatingElements: Bool
    private var indicesIterator: AnyIterator<Array<Int>>

    fileprivate init(sequence: S, length: Int, repeatingElements: Bool) {
        self.values = Array(sequence)
        self.combinationLength = length
        self.repeatingElements = repeatingElements
        if repeatingElements {
            self.indicesIterator = AnyIterator(product(values.indices, repeated: length))
        } else {
            self.indicesIterator = AnyIterator(Permutations(sequence: values.indices, length: length, repeatingElements: false))
        }
    }

    public mutating func next() -> [S.Iterator.Element]? {
        guard let indices = indicesIterator.next() else {
            return nil
        }

        guard indices.sorted() == indices else {
            return next()
        }

        let combination = indices.map { values[$0] }
        return combination.isEmpty ? nil : combination
    }
}
