//
//  Quantity+Operators.swift
//  JMQuantity
//
//  Created by Jeff on 10/11/17.
//  Copyright © 2017 Jeff McClay. All rights reserved.
//

import Foundation

//MARK: - Operators
extension Quantity: Comparable {
    
    public static func == <U>(lhs: Quantity<U>, rhs: Quantity<U>) -> Bool {
        if (lhs.unit == rhs.unit) {
            return lhs._value == rhs._value
        } else {
            let rhsConverted = rhs.convert(to: lhs.unit)
            return lhs._value == rhsConverted._value
        }
    }

    public static func < <U>(lhs: Quantity<U>, rhs: Quantity<U>) -> Bool {
        if (lhs.unit == rhs.unit) {
            return lhs._value < rhs._value
        } else {
            let rhsConverted = rhs.convert(to: lhs.unit)
            return lhs._value < rhsConverted._value
        }
    }

    public static func > <U>(lhs: Quantity<U>, rhs: Quantity<U>) -> Bool {
        if (lhs.unit == rhs.unit) {
            return lhs._value > rhs._value
        } else {
            let rhsConverted = rhs.convert(to: lhs.unit)
            return lhs._value > rhsConverted._value
        }
    }
}

infix operator --> //{associativity left}
public func --> <U>(lhs: Quantity<U>, rhs: PrefixedUnit<U>) -> Quantity<U> {
    return lhs.convert(to: rhs)
}

public func --> <U>(lhs: Quantity<U>, rhs: U) -> Quantity<U> {
    return lhs.convert(to: PrefixedUnit(baseUnit: rhs))
}

public prefix func - <U>(q: Quantity<U>) -> Quantity<U> {
    return Quantity(value: -q.value, unit: q.unit)
}

public func - <U>(lhs: Quantity<U>, rhs: Quantity<U>) -> Quantity<U> {
    if (lhs.unit == rhs.unit) {
        return Quantity(value:lhs.value - rhs.value, unit: lhs.unit)
    } else {
        let rhsConverted = rhs.convert(to: lhs.unit)
        return Quantity(value: lhs.value - rhsConverted.value, unit: lhs.unit)
    }
}

public func + <U>(lhs: Quantity<U>, rhs: Quantity<U>) -> Quantity<U> {
    if (lhs.unit == rhs.unit) {
        return Quantity(value:lhs.value + rhs.value, unit: lhs.unit)
    } else {
        let rhsConverted = rhs.convert(to: lhs.unit)
        return Quantity(value: lhs.value + rhsConverted.value, unit: lhs.unit)
    }
}

public func + <U>(lhs: Quantity<U>, rhs: Double) -> Quantity<U> {
    return Quantity(value:lhs.value + rhs, unit: lhs.unit)
}

public func / <S,T>(lhs: Quantity<S>, rhs: Quantity<T>) -> Quantity<RateUnit<S,T>> {
    let val = lhs.value/rhs.value
    let rateUnit = RateUnit(unit: lhs.unit, perUnit: rhs.unit)
    let q = Quantity(val, rateUnit)
    return q
}

