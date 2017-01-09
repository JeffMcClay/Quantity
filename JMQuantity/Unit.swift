//
//  Unit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public protocol Unit {
    var symbol: String { get }
    var name: String { get }
    
    func convert(quantity: Quantity<Self>, toPrefixedUnit: PrefixedUnit<Self>) -> Quantity<Self>
}

extension Unit {
    public var name: String { return String(describing: self) }
}


public protocol LinearUnit: Unit, RawRepresentable {
    var unitValue: Double { get }
}
extension LinearUnit {
    
    public var unitValue: Double {
        return self.rawValue as! Double
    }
    
    public func convert(quantity: Quantity<Self>, toPrefixedUnit: PrefixedUnit<Self>) -> Quantity<Self> {
        let baseUnit = quantity.unit.baseUnit
        let toUnit = toPrefixedUnit.baseUnit
        
        let baseValue = quantity._value / baseUnit.unitValue    // Convert to "meters"
        let newValue = baseValue * toUnit.unitValue / toPrefixedUnit.prefix.rawValue
        return Quantity(value: newValue, unit: toPrefixedUnit)
    }
    
}

//TODO: Better implementation of "Equals"
func ==<U: Unit>(lhs: U, rhs: U) -> Bool {
    return (lhs.symbol == rhs.symbol) && (lhs.name == rhs.name)
}
//func ==(lhs: LinearUnit, rhs: LinearUnit) -> Bool {
//    return (lhs.symbol == rhs.symbol) && (lhs.name == rhs.name) && (lhs.unitValue == rhs.unitValue)
//}

