//
//  Human.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

class Human {
    
    var pairs : [Connection]
    var bodyParts : [Int: BodyPart]
    var uidxList: Set<String>
    
    init(_ pairs: [Connection]) {
        
        self.pairs = [Connection]()
        self.bodyParts = [Int: BodyPart]()
        self.uidxList = Set<String>()
        
        for pair in pairs {
            self.addPair(pair)
        }
    }
    
    func _getUidx(_ partIdx: Int,_ idx: Int) -> String {
        return String(format: "%d-%d", partIdx, idx)
    }
    
    func addPair(_ pair: Connection) {
        self.pairs.append(pair)
        
        self.bodyParts[pair.partIdx1] = BodyPart(_getUidx(pair.partIdx1, pair.idx1),
                                                 pair.partIdx1,
                                                 pair.coord1.0, pair.coord1.1, pair.score)
        
        self.bodyParts[pair.partIdx2] = BodyPart(_getUidx(pair.partIdx2, pair.idx2),
                                                 pair.partIdx2,
                                                 pair.coord2.0, pair.coord2.1, pair.score)
        
        let uidx: [String] = [_getUidx(pair.partIdx1, pair.idx1),_getUidx(pair.partIdx2, pair.idx2)]
        self.uidxList.formUnion(uidx)
    }
    
    func merge(_ other: Human) {
        for pair in other.pairs {
            self.addPair(pair)
        }
    }
    
    func isConnected(_ other: Human) -> Bool {
        return uidxList.intersection(other.uidxList).count > 0
    }
    
    func partCount() -> Int {
        return self.bodyParts.count
    }
    
    func getMaxScore() -> Double {
        return max(self.bodyParts.map{ $0.value.score })
    }
    
}
