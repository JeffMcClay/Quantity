//
//  Quantity+PropertyListReadable.swift
//  JMQuantity
//
//  Created by Jeff on 10/13/17.
//  Copyright © 2017 Jeff McClay. All rights reserved.
//

import Foundation


extension Quantity : PropertyListReadable {
    public func propertyListRepresentation() -> NSDictionary {
        var dict = [String : Any]()
        dict["_value"] = self._value
        dict["unit"] = self.unit.propertyListRepresentation()
        return dict as NSDictionary
    }
    
    public init?(plist: NSDictionary?) {
        guard let values = plist else { return nil }
        let dict = values as! [String : Any]
        
        self._value = dict["_value"] as! Double
        let unitPlist = dict["unit"] as! NSDictionary
        self.unit = PrefixedUnit(plist: unitPlist)!
    }
}

extension PrefixedUnit : PropertyListReadable {
    public func propertyListRepresentation() -> NSDictionary {
        var dict = [String : Any]()
        dict["prefix"] = self.prefix.rawValue
        dict["unit"] = self.baseUnit.propertyListDescription()
        dict["__unitType"] = String(describing: type(of: self.baseUnit))
        return dict as NSDictionary
    }
    
    public init?(plist: NSDictionary?) {
        guard let values = plist else { return nil }
        let dict = values as! [String : Any]
        
        let prefix = dict["prefix"] as! Double
        self.prefix = SIPrefix(rawValue: prefix)!
        
        let unitTypeString = dict["__unitType"] as! String
        
        
        let unitDict = dict["unit"] as! [String : Any]
        
        switch(unitTypeString) {
        case "DistanceUnit": self.baseUnit = DistanceUnit(name: unitDict["name"] as! String) as! U
        case "VolumeUnit": self.baseUnit = VolumeUnit(name: unitDict["name"] as! String) as! U
        case "FuelUnit": self.baseUnit = FuelUnit(compositionDict: unitDict) as! U
        default: return nil
        }
    }
}


