//
//  PrefixedUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public struct PrefixedUnit<U: Unit> {
    /// The unit's prefix (eg. milli, micro, kilo, mega, etc)
    let prefix: SIPrefix

    /// The actual unit (eg. meters, feet, celcius, etc)
    let baseUnit: U

    /// Returns a short, abbreviated symbol describing this unit.
    /// - Example: will return "mm" for millimeters, and "inHg" for inches-of-mercury
    public var symbol: String {
        return "\(prefix)\(baseUnit.symbol)"
    }

    /// Returns a longer unabbreviated string describing this unit.
    public var longName: String {
        return "\(prefix.longName)\(baseUnit.name)"
    }

    /**
     Default `PrefixedUnit` constructor
     - parameter prefix: the SIPrefix value of this unit. Default is `.none`
     - parameter baseUnit: the actual unit
    */
    public init(prefix: SIPrefix = .none, baseUnit: U) {
        self.prefix = prefix
        self.baseUnit = baseUnit
    }

    /**
     Converts a given quantity to a different unit
     - parameter quantity: the quantity to convert
     - returns: the converted quantity
     */
    func convert(_ quantity: Quantity<U>) -> Quantity<U> {
        return baseUnit.convert(quantity, toPrefixedUnit: self)
    }
}

extension PrefixedUnit: CustomStringConvertible {
    public var description: String {
        return "\(prefix.longName)\(baseUnit.name)"
    }
}

extension PrefixedUnit: Equatable {
    /// Two prefixed units are considered equal when both their prefix and baseunit are equal
    static public func == <U>(lhs: PrefixedUnit<U>, rhs: PrefixedUnit<U>) -> Bool {
        return (lhs.baseUnit == rhs.baseUnit) && (lhs.prefix == rhs.prefix)
    }
}

