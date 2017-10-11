//
//  TemperatureUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation


enum TemperatureUnit: Unit {
    case fahrenheit
    case celcius
    
    var symbol : String {
        switch self {
        case .fahrenheit: return "F"
        case .celcius: return "C"
        }
    }
    
    func convert(_ quantity: Quantity<TemperatureUnit>, toPrefixedUnit: PrefixedUnit<TemperatureUnit>) -> Quantity<TemperatureUnit> {
        let from = quantity.unit.baseUnit
        if quantity.unit == toPrefixedUnit { return quantity }
        
        if from == .fahrenheit && toPrefixedUnit.baseUnit == .celcius {
            let c = (quantity.value - 32.0) * (5.0/9.0)
            return Quantity(value: c, unit: toPrefixedUnit)
        } else if from == .celcius && toPrefixedUnit.baseUnit == .fahrenheit {
            let f = (quantity.value * 1.8) + 32.0
            return Quantity(value: f, unit: toPrefixedUnit)
        }
        return quantity
    }
    
}
