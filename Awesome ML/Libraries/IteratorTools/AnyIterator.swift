//
//  AnyIterator.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 12/11/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


// c.f. http://chris.eidhof.nl/post/type-erasers-in-swift/
class AnyIterator<A>: IteratorProtocol {
    private let _next: () -> A?

    init<I: IteratorProtocol>(_ iterator: I) where I.Element == A {
        var iteratorCopy = iterator
        self._next = { iteratorCopy.next() }
    }

    func next() -> A? {
        return _next()
    }
}
