//
//  Quantity.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation


public struct Quantity<U: Unit> {
    //MARK: - Properties

    /**
     Stores Quantity's value converted to its base unit, with no prefix.
        Example: For a 2 Kilometer quantity, `_value = 2000`
        Example: For a 100 centimeter quantity, `_value = 1`
     */
    internal let _value: Double
    
    /// A PrefixedUnit struct containing an SIPrefix and a Unilinear unit enum.
    public let unit: PrefixedUnit<U>
    
    /// Returns the value of the quantity, expressed in the quantity's PrefixedUnit.
    public var value : Double {
        get { return _value / Double(unit.prefix.rawValue) }
    }

    /// Same as value, but converts from Double to Int.
    public var intValue: Int {
        get { return Int(_value) / Int(unit.prefix.rawValue) }
    }

    //MARK: - Initialization

    /**
     Default constructor for Quantities.
     - parameter value: the actual value of the quantity, in the units of the given `PrefixedUnit`
     - parameter unit: the `PrefixedUnit` for the quantity

     Example: create a quantity of 5.6 kilometers

         let km = PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter)
         let qty = Quantity(value: 5.6, unit: km)
     */
    public init(value: Double, unit: PrefixedUnit<U>) {
        self.unit = unit
        self._value = value * Double(unit.prefix.rawValue)
    }
    
    /**
     Convenience constructor for creating a quantity from a double value and a unit.
     - parameter value: the actual value of the quantity
     - parameter unit: the base unit of this quantity (eg. .meter, .foot, .celcius, etc)

     - Note: This creates a PrefixedUnit object for you, with a prefix of `.none`. If you need
             to make a quantity with with a prefix, please use the default constructor.
     */
    public init(_ value: Double, _ unit: U) {
        let pu = PrefixedUnit(prefix: .none, baseUnit: unit)
        self.init(value: value, unit:pu)
    }
    
    /**
     Convenience constructor cor creating a quantity from a double value, SI prefix, and a unit
     - parameter value: the actual value of the quantity
     - parameter prefix: the SI prefix of the quantity (eg. .milli, .micro, .kilo, .mega, etc)
     - parameter unit: the base unit of this quantity (eg. .meter, .foot, .celcius, etc)
     */
    public init(_ value: Double, prefix: SIPrefix = .none, baseUnit: U) {
        let pu = PrefixedUnit(prefix: prefix, baseUnit: baseUnit)
        self.init(value: value, unit:pu)
    }
    
    //MARK: - Conversion

    /**
     Converts a quantity from its current unit into a different unit
     - parameter to: the PrefixedUnit to convert this quantity into
     - returns: a new quantity, having been converted to the specified units
     */
    public func convert(to toPrefixedUnit: PrefixedUnit<U>) -> Quantity {
        return toPrefixedUnit.convert(self)
    }

    /**
     Converts a quantity from its current unit into a different unit
     - parameter to: the unit to convert this quantity into
     - returns: a new quantity, having been converted to the specified units

     - Note: this method takes a generic unit as its parameter, NOT a PrefixedUnit.  A new PrefixedUnit object will be
            created, with a prefix of .none and then this quantity will be converted to that PrefixedUnit. This is a
            convenience function for converting to units with no SI prefix (eg. "feet")
     */
    public func convert(to toUnit: U) -> Quantity {
        let pu = PrefixedUnit(baseUnit: toUnit)
        return pu.convert(self)
    }
}

extension Quantity: CustomStringConvertible {
    public var description: String { get {
        return value.description + " " + unit.symbol
        }
    }

    /**
     Returns a string description of a quantity, rounded to the specified number of digits
     - parameter decimalPlaces: rounds the quantity to this many digits. Default is 2.
     - parameter minDigits: the precise number of digits to display including any trailing zeros. Default is 0.
     - parameter separators: if set to true, comma separators will be added to the string.
     */
    public func roundedDescription(decimalPlaces: Int = 2, minDigits: Int = 0, separators: Bool = true) -> String {
        let f = NumberFormatter()
        f.minimumIntegerDigits = 1
        f.maximumFractionDigits = decimalPlaces
        f.minimumFractionDigits = minDigits
        if separators {f.numberStyle = .decimal}
        return f.string(from: NSNumber(value: value))! + " " + unit.symbol
    }

    /**
     Returns a string description of a quantity, rounded to exactly the specified number of digits
     - parameter exactDigits: rounds the quantity to exactly this many digits, including any trailing zeros.
     - parameter separators: if set to true, comma separators will be added to the string.
     - Note: this is a convenience version of roundedDescription(_:_:_)
     */
    public func roundedDescription(exactDigits d: Int, separators: Bool = true) -> String {
        return roundedDescription(decimalPlaces: d, minDigits: d, separators: separators)
    }
}
