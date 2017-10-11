//
//  AreaUnit.swift
//  JMQuantity
//
//  Created by Jeff on 6/3/16.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

enum AreaUnit<LU: LinearUnit>: Unit {
    
    case squareUnit(LU)
    
    var symbol: String {
        switch self {
        case .squareUnit(let unit):
            return unit.symbol + "²"
        }
    }
    var name: String {
        switch self {
        case .squareUnit(let unit):
            return "square" + unit.name
        }
    }
    
    init(unit: LU) {
        self = AreaUnit.squareUnit(unit)
    }
    
    func convert(_ quantity: Quantity<AreaUnit>, toPrefixedUnit: PrefixedUnit<AreaUnit>) -> Quantity<AreaUnit> {
        if quantity.unit == toPrefixedUnit { return quantity }

        switch quantity.unit.baseUnit {
        case .squareUnit(let unitFrom):
            switch toPrefixedUnit.baseUnit {
            case .squareUnit(let unitTo):
                let baseValue = quantity._value / pow(unitFrom.unitValue, 2) // convert to "meters"
                let newValue = baseValue * pow(unitTo.unitValue, 2) / toPrefixedUnit.prefix.rawValue
                return Quantity(value: newValue, unit: toPrefixedUnit)
            }
        }
    }
    
}
