//
//  URL + Extensions.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation

public extension URL {
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}

public func folderSize(folderPath: String) -> UInt {

    var filesArray: [String] = []
    var fileSize: UInt = 0
    
    do {
        filesArray = try FileManager.default.subpathsOfDirectory(atPath: folderPath) as [String]
    } catch let error as NSError {
        print("FileAttribute error: \(error)")
    }
    
    
    for fileName in filesArray {
        let filePath = (folderPath as NSString).appendingPathComponent(fileName)
        do {
            let fileDictionary:NSDictionary = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
            fileSize += UInt(fileDictionary.fileSize())
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
    }
    
    return fileSize
}
