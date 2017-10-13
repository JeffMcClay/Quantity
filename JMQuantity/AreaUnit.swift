//
//  AreaUnit.swift
//  JMQuantity
//
//  Created by Jeff on 6/3/16.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum AreaUnitSpecialTypes: Double {

    // Relative to 1 square mile
    case acre = 640
    case are = 25900

    public var symbol: String {
        switch self {
        case .acre: return "ac"
        case .are: return "a"
        }
    }
}

public enum AreaUnit: Unit {
    
    case squareUnit(PrefixedUnit<DistanceUnit>)
    case areaUnit(AreaUnitSpecialTypes)
    
    public var symbol: String {
        switch self {
        case .squareUnit(let unit): return unit.symbol + "²"
        case .areaUnit(let unit): return unit.symbol
        }
    }
    public var name: String {
        switch self {
        case .squareUnit(let unit): return "square" + unit.baseUnit.name
        case .areaUnit(let unit): return unit.symbol
        }
    }
    
    //MARK: - Initialization
    // Init with PrefixedUnit
    init(prefixedUnit: PrefixedUnit<DistanceUnit>) {
        self = AreaUnit.squareUnit(prefixedUnit)
    }
    init(_ prefixedUnit: PrefixedUnit<DistanceUnit>) {
        self.init(prefixedUnit:prefixedUnit)
    }
    
    // Init with DistanceUnit
    init(unit: DistanceUnit) {
        self.init(PrefixedUnit(unit))
    }
    init(_ unit: DistanceUnit) {
        self.init(PrefixedUnit(unit))
    }
    
    // Init with special area units
    init(areaUnit: AreaUnitSpecialTypes) {
        self = AreaUnit.areaUnit(areaUnit)
    }
    init(_ areaUnit: AreaUnitSpecialTypes) {
        self = AreaUnit.areaUnit(areaUnit)
    }
    
    //MARK: - Conversion
    public func convert(_ quantity: Quantity<AreaUnit>, toPrefixedUnit: PrefixedUnit<AreaUnit>) -> Quantity<AreaUnit> {
        if quantity.unit == toPrefixedUnit { return quantity }
        
        let newValue: Double
        switch quantity.unit.baseUnit {
        case .squareUnit(let unitFrom):
            let from = unitFrom.baseUnit.unitValue
            let baseValue = quantity._value / (from * from) //pow(2)
            switch toPrefixedUnit.baseUnit {
            case .squareUnit(let unitTo):
                newValue = baseValue * (unitTo.baseUnit.unitValue * unitTo.baseUnit.unitValue) //pow(2)
            case .areaUnit(let unitTo):
                newValue = baseValue * unitTo.rawValue
            }
            
        case .areaUnit(let unitFrom):
            let baseValue = quantity._value / unitFrom.rawValue
            switch toPrefixedUnit.baseUnit {
            case .squareUnit(let unitTo):
                newValue = baseValue * (unitTo.baseUnit.unitValue * unitTo.baseUnit.unitValue)  //pow(2)
            case .areaUnit(let unitTo): newValue = baseValue * unitTo.rawValue
            }
        }
        
        let retValue = newValue / toPrefixedUnit.prefix.rawValue    // Handle prefix
        return Quantity(value: retValue, unit: toPrefixedUnit)
    }

}

public func * (lhs: Distance, rhs: Distance) -> Quantity<AreaUnit> {
    let r = rhs.convert(to: lhs.unit)
    let val = lhs.value * r.value
    let q = Quantity(val, unit: AreaUnit.squareUnit(lhs.unit))
    return q
}

