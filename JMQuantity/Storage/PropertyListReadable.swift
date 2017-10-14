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
//    init?(plistData: NSData?)
}

public extension PropertyListReadable {
    public func propertyListData() -> NSData {
        let plist = self.propertyListRepresentation()
        let data = NSKeyedArchiver.archivedData(withRootObject: plist)
        return data as NSData
    }
}

public extension NSData {
    func quantityPropertyList() -> NSDictionary {
        return NSKeyedUnarchiver.unarchiveObject(with: self as Data) as! NSDictionary
    }
}
