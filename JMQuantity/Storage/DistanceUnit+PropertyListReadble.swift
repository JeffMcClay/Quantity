//
//  DistanceUnit+PropertyListReadble.swift
//  JMQuantity
//
//  Created by Jeff on 10/13/17.
//  Copyright © 2017 Jeff McClay. All rights reserved.
//

import Foundation

extension DistanceUnit: ExpressibleByStringLiteral {
    public init(name value: String) {
        switch (value) {
        case "inch": self = .inch
        case "foot": self = .foot
        case "yard": self = .yard
        case "mile": self = .mile
        case "nauticalMile": self = .nauticalMile
        case "rod": self = .rod
        case "chain": self = .chain
        case "furlong": self = .furlong
        case "fathom": self = .fathom
        default: self = .meter
        }
    }
    
    public init(stringLiteral value: String) {
        self.init(name: value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(name: value)
    }
}

extension VolumeUnit: ExpressibleByStringLiteral {
    public init(name value: String) {
        switch (value) {
        case "gallonUS": self = .gallonUS
        case "gallonImperial": self = .gallonImperial
        default: self = .liter
        }
    }
    
    public init(stringLiteral value: String) {
        self.init(name: value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(name: value)
    }
}


let kJMQuantityFuelUnitDistUnitTypeKey = "distUnitType"
let kJMQuantityFuelUnitDistUnitPrefix = "distUnitPrefix"
let kJMQuantityFuelUnitVolUnitType = "volUnitType"
let kJMQuantityFuelUnitVolUnitPrefix = "volUnitPrefix"
let kJMQuantityFuelUnitScalarValue = "scalarValue"

extension FuelUnit {
    
    public init?(compositionDict dict: [String: Any]) {
        let type = dict["__type"] as! String
        let distUnit = DistanceUnit(name: dict[kJMQuantityFuelUnitDistUnitTypeKey] as! String)
        let distPrefix = SIPrefix(rawValue: dict[kJMQuantityFuelUnitDistUnitPrefix] as! Double)
        let volUnit = VolumeUnit(name: dict[kJMQuantityFuelUnitVolUnitType] as! String)
        let volPrefix = SIPrefix(rawValue: dict[kJMQuantityFuelUnitVolUnitPrefix] as! Double)
        let scalar = dict[kJMQuantityFuelUnitScalarValue] as! ScalarType
        
        let puDist = PrefixedUnit(distPrefix!, distUnit)
        let puVol = PrefixedUnit(volPrefix!, volUnit)
        
        if (type == "distPerVol") {
            self.init(distance: puDist, per: scalar, puVol)
        } else  if (type == "volPerDist") {
            self.init(volume: puVol, per: scalar, puDist)
        } else {
            return nil
        }
    }
    
    public var unitCompositionDictionary: [String: Any] {
        var dict = [String : Any]()
        dict["name"] = self.name
        switch (self) {
        case .distPerVol(let dist, let vol, let scalar):
            dict["__type"] = "distPerVol"
            dict[kJMQuantityFuelUnitDistUnitTypeKey] = dist.baseUnit.name
            dict[kJMQuantityFuelUnitDistUnitPrefix] = dist.prefix.rawValue
            dict[kJMQuantityFuelUnitVolUnitType] = vol.baseUnit.name
            dict[kJMQuantityFuelUnitVolUnitPrefix] = vol.prefix.rawValue
            dict[kJMQuantityFuelUnitScalarValue] = scalar
        case .volPerDist(let vol, let dist, let scalar):
            dict[kJMQuantityFuelUnitDistUnitTypeKey] = dist.baseUnit.name
            dict[kJMQuantityFuelUnitDistUnitPrefix] = dist.prefix.rawValue
            dict[kJMQuantityFuelUnitVolUnitType] = vol.baseUnit.name
            dict[kJMQuantityFuelUnitVolUnitPrefix] = vol.prefix.rawValue
            dict[kJMQuantityFuelUnitScalarValue] = scalar
        }
        return dict
    }
    
    public func propertyListDescription() -> NSDictionary {
        return unitCompositionDictionary as NSDictionary
    }
}

