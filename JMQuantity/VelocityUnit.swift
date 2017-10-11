//
//  VelocityUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

typealias VelocityUnit = RateUnit<DistanceUnit, TimeUnit>

//enum VelocityUnit: Unit {
//
//    case Rate(DistanceUnit, TimeUnit)
//    
//    var symbol: String {
//        switch self {
//        case .Rate(let dist, let time):
//            return dist.symbol + "/" + time.symbol
//        }
//    }
//    var name: String {
//        switch self {
//        case .Rate(let dist, let time):
//            return dist.name + " per " + time.name
//        }
//    }
//    
//    init(distanceUnit unit: DistanceUnit, perTimeUnit timeUnit: TimeUnit) {
//        self = VelocityUnit.Rate(unit, timeUnit)
//    }
//    init(_ unit: DistanceUnit, per timeUnit: TimeUnit) {
//        self = VelocityUnit.Rate(unit, timeUnit)
//    }
//    
//    
//    func convert(quantity: Quantity<VelocityUnit>, toPrefixedUnit: PrefixedUnit<VelocityUnit>) -> Quantity<VelocityUnit> {
//        if quantity.unit == toPrefixedUnit { return quantity }
//        
//        switch quantity.unit.baseUnit {
//        case .Rate(let distFrom, let timeFrom):
//            switch toPrefixedUnit.baseUnit {
//            case .Rate(let distTo, let timeTo):
//                let baseValue = quantity._value / distFrom.unitValue * timeFrom.unitValue // convert to "meters"
//                let newValue = baseValue * distTo.unitValue / timeTo.unitValue / toPrefixedUnit.prefix.rawValue
//                return Quantity(value: newValue, unit: toPrefixedUnit)
//            }
//        }
//    }
//    
//}