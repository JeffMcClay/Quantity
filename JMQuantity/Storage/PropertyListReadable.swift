//
//  PropertyListReadable.swift
//  JMQuantity
//
//  Created by Jeff on 10/13/17.
//  Copyright © 2017 Jeff McClay. All rights reserved.
//

import Foundation

public protocol PropertyListReadable {
    func propertyListRepresentation() -> NSDictionary
    init?(plist: NSDictionary?)
}

public extension PropertyListReadable {
    public func dataForCoreData() -> NSData {
        let plist = self.propertyListRepresentation()
        let data = NSKeyedArchiver.archivedData(withRootObject: plist)
        return data as NSData
    }
    
    public static func plistFrom(data: NSData) -> [String : Any] {
        let plist = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSDictionary
        return plist as! [String : Any]
    }
}
