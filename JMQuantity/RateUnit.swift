//
//  RateUnit.swift
//  JMQuantity
//
//  Created by Jeff on 6/3/16.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum RateUnit<MainUnit: LinearUnit, ChangeUnit: LinearUnit>: Unit {
    
    case rate(PrefixedUnit<MainUnit>, PrefixedUnit<ChangeUnit>)
    
    public var symbol: String {
        switch self {
        case .rate(let dist, let time):
            return dist.symbol + "/" + time.symbol
        }
    }
    public var name: String {
        switch self {
        case .rate(let dist, let time):
            return dist.symbol + " per " + time.symbol
        }
    }
    
    init(unit: PrefixedUnit<MainUnit>, perUnit changeUnit: PrefixedUnit<ChangeUnit>) {
        self = RateUnit.rate(unit, changeUnit)
    }
    init(_ unit: PrefixedUnit<MainUnit>, per changeUnit: PrefixedUnit<ChangeUnit>) {
        self = RateUnit.rate(unit, changeUnit)
    }
    init(_ unit: MainUnit, per changeUnit: ChangeUnit) {
        self = RateUnit.rate(PrefixedUnit(baseUnit: unit), PrefixedUnit(baseUnit: changeUnit))
    }

    public func convert(_ quantity: Quantity<RateUnit>, toPrefixedUnit: PrefixedUnit<RateUnit>) -> Quantity<RateUnit> {
        if quantity.unit == toPrefixedUnit { return quantity }

        switch quantity.unit.baseUnit {
        case .rate(let mainFrom, let changeFrom):
            switch toPrefixedUnit.baseUnit {
            case .rate(let mainTo, let changeTo):
                
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
