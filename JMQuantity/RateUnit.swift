//
//  RateUnit.swift
//  JMQuantity
//
//  Created by Jeff on 6/3/16.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

enum RateUnit<MainUnit: LinearUnit, ChangeUnit: LinearUnit>: Unit {
    
    case Rate(PrefixedUnit<MainUnit>, PrefixedUnit<ChangeUnit>)
    
    var symbol: String {
        switch self {
        case .Rate(let dist, let time):
            return dist.symbol + "/" + time.symbol
        }
    }
    var name: String {
        switch self {
        case .Rate(let dist, let time):
            return dist.symbol + " per " + time.symbol
        }
    }
    
    init(unit: PrefixedUnit<MainUnit>, perUnit changeUnit: PrefixedUnit<ChangeUnit>) {
        self = RateUnit.Rate(unit, changeUnit)
    }
    init(_ unit: PrefixedUnit<MainUnit>, per changeUnit: PrefixedUnit<ChangeUnit>) {
        self = RateUnit.Rate(unit, changeUnit)
    }
    init(_ unit: MainUnit, per changeUnit: ChangeUnit) {
        self = RateUnit.Rate(PrefixedUnit(baseUnit: unit), PrefixedUnit(baseUnit: changeUnit))
    }

    func convert(quantity: Quantity<RateUnit>, toPrefixedUnit: PrefixedUnit<RateUnit>) -> Quantity<RateUnit> {
        if quantity.unit == toPrefixedUnit { return quantity }

        switch quantity.unit.baseUnit {
        case .Rate(let mainFrom, let changeFrom):
            switch toPrefixedUnit.baseUnit {
            case .Rate(let mainTo, let changeTo):
                
//                let main = mainFrom.baseUnit
//                if let main = main as? LinearUnit { print("all good") }
//                if mainFrom.baseUnit is LinearUnit { "all good" }
                
                // Convert the numerator
                let num_pu = PrefixedUnit(prefix: mainFrom.prefix, baseUnit: mainFrom.baseUnit)
                let numerator = Quantity(value: quantity.value, unit: num_pu)
                let num_c = numerator --> mainTo
                
                // Convert the denominator
                let den_pu = PrefixedUnit(prefix: changeFrom.prefix, baseUnit: changeFrom.baseUnit)
                let denominator = Quantity(value: 1, unit: den_pu)
                let den_c = denominator --> changeTo
                
                // Finish the conversion, and apply the prefix
                let nonPrefixedValue = num_c.value / den_c.value / toPrefixedUnit.prefix.rawValue
                let q = Quantity(value: nonPrefixedValue, unit: toPrefixedUnit)
                
                return q
                
            }
        }
    }
    
    
}
