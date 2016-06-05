//
//  TemperatureUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation


enum TemperatureUnit: Unit {
    case Fahrenheit
    case Celcius
    
    var symbol : String {
        switch self {
        case .Fahrenheit: return "F"
        case .Celcius: return "C"
        }
    }
    
    func convert(quantity: Quantity<TemperatureUnit>, toPrefixedUnit: PrefixedUnit<TemperatureUnit>) -> Quantity<TemperatureUnit> {
        let from = quantity.unit.baseUnit
        if quantity.unit == toPrefixedUnit { return quantity }
        
        if from == .Fahrenheit && toPrefixedUnit.baseUnit == .Celcius {
            let c = (quantity.value - 32.0) * (5.0/9.0)
            return Quantity(value: c, unit: toPrefixedUnit)
        } else if from == .Celcius && toPrefixedUnit.baseUnit == .Fahrenheit {
            let f = (quantity.value * 1.8) + 32.0
            return Quantity(value: f, unit: toPrefixedUnit)
        }
        return quantity
    }
    
}